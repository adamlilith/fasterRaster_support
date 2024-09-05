# TESTING

rm(list=ls())
# library(fasterRaster)
library(omnibus)
library(sf)
library(terra)
library(rgrass)

drive <- 'C:'
# drive <- 'E:'
grassDir <- paste0('C:/Program Files/GRASS GIS 8.2') # example for a PC

ff <- listFiles(paste0(drive, '/ecology/Drive/R/fasterRaster/R'))
for (f in ff) source (f)


###

madChelsa <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madChelsa.tif'))
madElev <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madElev.tif'))
madElevSmall <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madElevSmall.tif'))
madElevAnt <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madElevAnt.tif'))
madElevMan <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madElevMan.tif'))
madElev <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madElev.tif'))
madForest2000 <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madForest2000.tif'))
madForest2014 <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madForest2014.tif'))
load(paste0(drive, '/Ecology/Drive/R/fasterRaster/data/madCoast0.rda'))
load(paste0(drive, '/Ecology/Drive/R/fasterRaster/data/madCoast4.rda'))
load(paste0(drive, '/Ecology/Drive/R/fasterRaster/data/madDypsis.rda'))
load(paste0(drive, '/Ecology/Drive/R/fasterRaster/data/madRivers.rda'))

fasterSetOptions(grassDir=grassDir)
replace <- FALSE
grassToR <- TRUE
autoRegion <- TRUE
trimRast <- TRUE


rast <- inRastName <- vect <- inVectName <- NULL

inits <- list(
	rast = rast,
	inRastName = inRastName,
	vect = vect,
	inVectName = inVectName,
	location = 'examples',
	restartGrass = TRUE
)

dots <- list()

