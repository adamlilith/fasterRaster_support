### CREATE fasterRaster DATA
### Adam B. Smith | Missouri Botanical Garden | adam.smith@mobot.org | 2023-01
###
### source('C:/Ecology/Drive/R/fasterRaster_support/create_fasterRaster_data.r')

#############
### setup ###
#############

	# rm(list=ls())
	# library(enmSdmX)
	# library(sf)
	# library(terra)
	
#############################
### save fasterHelp table ###
#############################	
	
	fasterFunctions <- read.csv('C:/Ecology/Drive/R/fasterRaster_support/fasterFunctions.csv')
	save(fasterFunctions, file='C:/Ecology/Drive/R/fasterRaster/data/fasterFunctions.rda', compression_level=9)
	
# #################################
# ### crop CHELSA to Madagascar ###
# #################################

	# bc <- c(1, 7, 12, 15)

	# load('C:/Ecology/Drive/R/fasterRaster/data/madCoast0.rda')
	# madCoast0 <- st_transform(madCoast0, getCRS('wgs84'))
	
	# chelsa <- rast(paste0('C:/Ecology/Drive/Research Data/CHELSA/chelsa_2.1_historical_1981_2010/CHELSA_bio', bc, '_1981-2010_V.2.1.tif'))

	# names(chelsa) <- paste0('bio', bc)
	# chelsa <- crop(chelsa, madCoast0)

	# chelsa <- round(chelsa, 2)
	# writeRaster(chelsa, 'C:/Ecology/Drive/R/fasterRaster/inst/extdata/madChelsa.tif', overwrite=TRUE, datatype='FLT4S')
	
# ###############################
# ### select GBIF occurrences ###
# ###############################	

	# ### select a taxon that has been sampled sufficiently to be interesting
	
	# madChelsa <- rast('C:/Ecology/Drive/R/fasterRaster/inst/extdata/madChelsa.tif')

	# ll <- c('decimalLongitude', 'decimalLatitude')
	# gbif <- read.csv('C:/Ecology/Drive/R/fasterRaster_support/gbif/occurrence.csv')

	# ok <- complete.cases(gbif[ , ll])
	# gbif <- gbif[ok, ]
	
	# ok <- complete.cases(gbif$species)
	# gbif <- gbif[ok, ]
	
	# ok <- gbif$species != ''
	# gbif <- gbif[ok, ]
	
	# gbif <- vect(gbif, geom=ll, crs=getCRS('wgs84'))

	# # most-collected genus is Dypsis
	# madDypsis <- gbif[gbif$genus == 'Dypsis', ]
	# extr <- extract(madChelsa, madDypsis)
	# madDypsis <- madDypsis[complete.cases(extr), ]

	

	# cols <- c('gbifID', )
	
	# dyp <- as.data.frame(madDypsis)
	# write.csv(madDypsis, 'C:/Ecology/Drive/R/fasterRaster_support/gbif/dypsis.csv', row.names=F)
	