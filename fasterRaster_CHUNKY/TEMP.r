# source('C:/Ecology/Drive/R/fasterRaster_support/TEMP.r')

# TESTING

rm(list=ls())
# library(fasterRaster)
library(omnibus)
library(sf)
library(terra)

drive <- 'C:'
# drive <- 'E:'
grassDir <- paste0('C:/Program Files/GRASS GIS 8.2') # example for a PC

ff <- listFiles(paste0(drive, '/ecology/Drive/R/fasterRaster/R'))
for (f in ff) source (f)


###

madChelsa <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madChelsa.tif'))
madElev <- rast(paste0(drive, '/Ecology/Drive/R/fasterRaster/inst/extdata/madElev.tif'))
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

levels <- c(0, 100, 200, 300, 400, 500)

# conts <- fasterContour(madElev, levels=levels, grassDir=grassDir, replace=TRUE, location='test3')
conts <- fasterContour(madElev, levels=levels, replace=TRUE, location='test3')
