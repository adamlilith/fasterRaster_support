# !!! fasterRaster STARTUP FOR DEVELOPMENT

rm(list = ls())
drive <- "C:/ecology"
# drive <- "E:/Adam/"

.libPaths(paste0(drive, "/R/libraries"))

library(data.table)
library(dismo)
library(raster)
library(sf)
library(terra)
# devtools::document(paste0(drive, "/R/fasterRaster"))
# devtools::load_all(paste0(drive, "/R/fasterRaster"))

# .frdoc(tolower(substr(drive, 1, 1)))
.frloadall(tolower(substr(drive, 1, 1)))

# grassDir <- "C:/Program Files/GRASS GIS 8.3"
# addons <- paste0(grassDir, "/addons")
# addons <- "C:/Users/adam/AppData/Roaming/GRASS8/addons"
# .backdoor()

# madElev <- fastData('madElev')
# madForest2000 <- fastData('madForest2000')
# madForest2014 <- fastData('madForest2014')
# madChelsa <- fastData('madChelsa')
# madRivers <- fastData('madRivers')
# madDypsis <- fastData('madDypsis')
# madCoast0 <- fastData('madCoast0')
# madCoast4 <- fastData('madCoast4')
# madChelsa <- fastData('madChelsa')
# madCover <- fastData('madCover')
# madLANDSAT <- fastData('madLANDSAT')

# elev <- fast(madElev)
# forest <- fast(madForest2000)
# rivers <- fast(madRivers)
# dypsis <- fast(madDypsis)
# chelsa <- fast(madChelsa)
# cover <- fast(madCover)
# coast0 <- fast(madCoast0)
# coast4 <- fast(madCoast4)
# landsat <- fast(madLANDSAT, checkCRS = FALSE)

# rgrass::execGRASS(
# 	cmd = "d.mon",
# 	start = "wx0",
# 	flags = "x"
# )

# rgrass::execGRASS(
# 	cmd = "d.vect",
# 	map = sources(dypsis)
# )

# BIOCLIMS
tmaxFiles <- paste0(drive, '/R/fasterraster_support/tmax.tif')
tminFiles <- paste0(drive, '/R/fasterraster_support/tmin.tif')
pptFiles <- paste0(drive, '/R/fasterraster_support/ppt.tif')

pptSR <- rast(pptFiles)
tminSR <- rast(tminFiles)
tmaxSR <- rast(tmaxFiles)

omnibus::say('Ingesting...')
pptGR <- fast(pptSR)
tmaxGR <- fast(tmaxSR)
tminGR <- fast(tminSR)

ppt <- pptGR
tmin <- tminGR
tmax <- tmaxGR

tmean <- NULL
bios <- "+"
# sample <- TRUE
sample <- FALSE
quarter <- 3
pptDelta <- 1


bcSR <- bioclims(ppt = pptSR, tmin = tminSR, tmax = tmaxSR, bios = '*')
# bcRL <- dismo::biovars(prec = raster::stack(pptSR), tmin = raster::stack(tminSR), tmax = raster::stack(tmaxSR))
bcGR <- bioclims(ppt = ppt, tmin = tmin, tmax = tmax, bios = '*')


# pptByQuarterSR <- .calcQuarterSR(pptSR, fun = "sum", quarter = quarter)
# pptByQuarterGR <- .calcQuarterGR(sources(pptGR), fun = "sum", quarter = quarter)
# pptByQuarterGR <- .makeGRaster(pptByQuarterGR, paste0("ppt", 1:12))

# pptByQuarterSR
# pptByQuarterGR

