# GENERATE DATA FOR fragmentation PACKAGE
# Adam B. Smith

rm(list=ls())
library(enmSdmX)
library(terra)

forest <- rast('C:/Ecology/Drive/Research/fasterRaster - Streamlined GIS in R through GRASS/data/Global Forest Watch - Forest Cover/ORIGINALS/Hansen_GFC2014_treecover2000_00N_010E.tif')

# basins <- vect('C:/Ecology/Drive/Research/fasterRaster - Streamlined GIS in R through GRASS/data/HydroSHEDS_BAS - African Basins/data/commondata/data0/af_bas_30s_beta.shp')
# basins <- project(basins, crs(forest))

plot(forest)
# plot(basins, add=TRUE)

# basin <- basins[basins$BASIN_ID == 52353, ]

extent <- c(13.22981, 13.56207, -4.143647, -3.849301)
extent <- ext(extent)

forest <- crop(forest, extent)
names(forest) <- 'rocForest'

writeRaster(forest, 'C:/Ecology/Drive/R/fragmentation/inst/extdata/rocForest.tif', datatype='INT2U', overwrite=TRUE)
