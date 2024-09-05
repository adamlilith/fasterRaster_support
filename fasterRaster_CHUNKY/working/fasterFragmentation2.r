	flags <- c('quiet', 'overwrite')
	
	# initialize GRASS
	input <- initGrass(rast=rast, vect=NULL, inRastName=inRastName, inVectName=NULL, grassDir=grassDir)
	
	# recode 1/0 (forest/no forest)
	ex <- paste0('forest = if(isnull(', input[['rastNameInGrass']], '), 0, 1)')
	fasterApp(input[['rastNameInGrass']], expression=ex, grassDir=grassDir, grassToR=FALSE, outGrassName='forest')

	### compute pf
	##############
		
		# recode 0/1 (forest/nonforest)
		ex <- 'nonforest = if(forest==0, 1, 0)'
		fasterApp('forest', expression=ex, grassDir=grassDir, grassToR=FALSE, outGrassName='forest')
		
		# pf forest
		fasterFocal('forest', fun='sum', w=w, grassDir=grassDir, grassToR=FALSE, outGrassName='forestInWindow')

		# pf non-forest
		fasterFocal('nonforest', fun='sum', w=w, grassDir=grassDir, grassToR=FALSE, outGrassName='nonforestInWindow')
		
		# denominator
		ex <- 'denom = forest + nonforest'
		fasterApp('forest', expression=ex, grassDir=grassDir, grassToR=FALSE, outGrassName='denom')

		# pf
		ex <- 'pf = forest / denom'
		pf <- fasterApp('forest', expression=ex, grassDir=grassDir, grassToR=TRUE, outGrassName='pf')
		
	### compute pff
	###############
	
		# neighboring forest cells
		ex <- 'forestPairs = (forest * forest[1, 0]) + (forest * forest[-1, 0]) + (forest * forest[0, -1]) + (forest * forest[0, 1])' 
		fasterApp('forest', expression=ex, grassDir=grassDir, grassToR=FALSE, outGrassName='forestPairs')
		
r.mapcalc "F4 = (A*A[1,0])+(A*A[-1,0])+(A*A[0,-1])+(A*A[0,1])" 
		
 
echo "computing Pff values ..."
# number of forest-forest pairs for each forest pixel in the 4 cardinal directions
# 0--x--0
# |  |  |
# x--x--x
# |  |  |
# 0--x--0
r.mapcalc "F4 = (A*A[1,0])+(A*A[-1,0])+(A*A[0,-1])+(A*A[0,1])" 
# sum on the sliding window
r.neighbors input=F4 output=F5 method=sum size="$GIS_OPT_WINDOW" --o

# number of forest-nonforest pairs for each forest pixel in the 4 cardinal directions
r.mapcalc "F6 = 4*A" 
# sum on the sliding window
r.neighbors input=F6 output=F7 method=sum size="$GIS_OPT_WINDOW" --o
 
# create Pff map
r.mapcalc << EOF
F8 = 1.0 * F5
F9 = 1.0 * F7
Pff = (F8/F9)
EOF
r.mapcalc "Pff_t=if(isnull(Pff),0,Pff)"
r.mapcalc "Pff=Pff_t"

 
echo "computing fragmentation index ..."
#frag model
# (1) interior, for which Pf = 1.0; (2) patch, Pf < 0.4; (3) transitional, 
# 0.4 <= Pf < 0.6; (4) edge,Pf >= 0.6 and Pf - Pff < 0; (5) perforated, 
# Pf >= 0.6 and Pf – Pff > 0, and (6) undetermined, Pf >= 0.6 and Pf = Pff
#
#code   Category        Pf                Pf4     Pff              Pff3
# 1     Patch           < 0.4             1
# 2     Transitional    >= 0.4 && < 0.6   2
# 3     Edge            >= 0.6 && < 1     3       Pf - Pff <= 0    1
# 4     Perforated      >= 0.6 && < 1     3       Pf – Pff > 0     2
# 5     Interior        1                 4   
 
# Pff3 (recode Pf - Pff)
r.mapcalc "Pff2 = Pf-Pff"
r.mapcalc "Pff3 = (if(Pff2<=0,1))+(if(Pff2>0,2))"

# Pf4 (recode Pf) 
#0-.4        1
#.4 - .6     2
#.6 - < 1    3
#1           4
r.mapcalc "Pf4 = (if(Pf<0.4,1))+(if(Pf>=0.4 && Pf<0.6,2))+(if(Pf>=0.6 && Pf<1,3))+(if(Pf==1,4))"
 
 
r.mapcalc "F11 = Pf4==1"
r.mapcalc "F21 = Pf4==2"
r.mapcalc "F31 = (Pf4==3) && (Pff3==1)"
r.mapcalc "F41 = (Pf4==3) && (Pff3==2)"
r.mapcalc "F51 = Pf==1"
 
r.mapcalc "index = if(if(F11==1,1))+(if(F21==1,2))+(if(F31==1,3))+(if(F41==1,4))+(if (F51==1,5))"
 
r.mapcalc "indexfin2 = (A*index)"
 
#create color codes
echo "creating color codes and categories ..."
r.colors indexfin2 color=rules << EOF
0 yellow
1 215:48:39
2 252:141:89
3 254:224:139
4 217:239:139
5 26:152:80
EOF
 
#create categories
cat ./fragindex/recl.txt
cat ./fragindex/recl.txt | r.reclass indexfin2 out=indexfin3 title="frag index" --o
 
r.mapcalc fragindex_run=indexfin3
 
if [ $GIS_FLAG_R -eq 1 ] ; then
  echo "Temporary files deleted ...."
  g.remove rast=A,B,C,D,E,F,F11,F21,F31,F4,F41,F5,F51,F6,F7,F8,F9,Pf,Pff,Pff_t,Pff2,Pff3,Pf4,veg
  g.remove rast=indexfin3
  g.remove rast=indexfin2
  g.remove rast=index
fi
 
#create color codes
r.colors fragindex_run color=rules << EOF
0 yellow
1 215:48:39
2 252:141:89
3 254:224:139
4 217:239:139
5 26:152:80
EOF
 
#display output maps
 
echo "generate map reports ..."
r.report map=fragindex_run units=h,p null=* nsteps=255 -e -i 
