#' Puts region extent and resolution into .fasterRaster environment
#'
#' This function is useful for reverting a region after it is reshaped for a particulatr operation. It saves extent, resolution, and dimensions in the .fasterRaster environment for later retrieval.
#'
#' @return TRUE (invisbly). Assigns values for region extent, resolution, and dimensions in the .fasterRaster environment.
#'
#' @keywords internal
.rememberRegion <- function(
) {

	regExt <- regionExtent()
	regDim <- regionDim()
	regRes <- regionRes()

	if (!exists('.fasterRaster')) .fasterRaster <- new.env(FALSE, parent=emptyenv())
	
	assign('regExt', regExt, envir=.fasterRaster)
	assign('regDim', regDim, envir=.fasterRaster)
	assign('regRes', regRes, envir=.fasterRaster)
	
	invisible(TRUE)
	
}

#' Reverts a region from settings stored in the .fasterRaster environment
#'
#' @return TRUE (invisibly). Resizes and resamples the region.
#' @keywords internal
.restoreRegion <- function() {

	if (!exists('.fasterRaster')) {
		stop('Environment .fasterRaster does not exist.')
	} else {
		regExt <- get('regExt', envir=.fasterRaster)
		regDim <- get('regDim', envir=.fasterRaster)
	}

	regExt <- as.character(regExt)

	rgrass::execGRASS(
		'g.region',
		w = regExt[1L],
		e = regExt[2L],
		s = regExt[3L],
		n = regExt[4L],
		rows = regDim[1L],
		cols = regDim[2L],
		flags = 'quiet'
	)
	
	invisible(TRUE)

}

#' Reverts a region's resolution
#'
#' @return TRUE (invisibly). Resizes and resamples the region.
#' @keywords internal
.restoreRegionRes <- function() {

	if (!exists('.fasterRaster', where=.GlobalEnv)) {
		stop('Environment .fasterRaster does not exist.')
	} else {
		regRes <- get('regRes', envir=.fasterRaster)
	}

	regRes <- as.character(regRes)

	rgrass::execGRASS(
		'g.region',
		ewres = regRes[1L],
		nsres = regres[2L],
		flags = 'quiet'
	)
	
	invisible(TRUE)

}

#' Reverts a region's extent
#'
#' @return TRUE (invisibly). Resizes and resamples the region.
#' @keywords internal
.restoreRegionExt <- function() {

	if (!exists('.fasterRaster')) {
		stop('Environment .fasterRaster does not exist.')
	} else {
		regExt <- get('regExt', envir=.fasterRaster)
	}

	regExt <- as.character(regExt)

	rgrass::execGRASS(
		'g.region',
		w = regExt[1L],
		e = regExt[2L],
		s = regExt[3L],
		n = regExt[4L],
		flags = 'quiet'
	)
	
	invisible(TRUE)

}

#' Reverts a region's dimensions
#'
#' @return TRUE (invisibly). Resizes and resamples the region.
#' @keywords internal
.restoreRegionDims <- function() {

	if (!exists('.fasterRaster')) {
		stop('Environment .fasterRaster does not exist.')
	} else {
		regDim <- get('regDim', envir=.fasterRaster)
	}

	rgrass::execGRASS(
		'g.region',
		rows = regDim[1L],
		cols = regDim[2L],
		flags = 'quiet'
	)
	
	invisible(TRUE)

}
