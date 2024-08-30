# fasterRaster checking

rm(list = ls())
drive <- "C:/ecology/Drive/"
# drive <- 'E:'

.libPaths(paste0(drive, "/R/libraries"))
if ('package:fasterRaster' %in% search()) detach('fasterRaster')

setwd(paste0(drive, '/R/fasterRaster'))

f <- paste0(drive, '/R/fasterRaster/NAMESPACE')
if (file.exists(f)) {
	file.remove(f)
	Sys.sleep(5)
}

devtools::document()
# devtools::load_all()

flush.console()

f <- paste0(drive, '/R/fasterRaster/junk')
if (file.exists(f)) {
	file.remove(f)
	Sys.sleep(5)
}

f <- paste0(drive, '/R/libraries/fasterRaster')
if (file.exists(f)) {
	file.remove(f, recursive=TRUE)
	Sys.sleep(5)
}

devtools::install(args='--no-lock', upgrade='never')
cat('\n\n\n')
flush.console()

	.fasterRaster <<- new.env(parent = emptyenv())
	.fasterRaster$grassStarted <- FALSE
	.fasterRaster$locations <- list()
	.fasterRaster$activeLocation <- NA_character_
	.fasterRaster$messages <- list()
	.fasterRaster$options <- list()

sink(paste0(drive, '/R/fasterRaster_support/!CHECK.txt'), split=TRUE)
devtools::check(document = FALSE, cran = TRUE)
sink()
flush.console()
