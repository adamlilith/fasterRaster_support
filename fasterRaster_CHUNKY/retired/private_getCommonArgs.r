#' Get common arguments
#'
#' For internal use only.
#' @param grassDir,replace,grassToR,outVectClass,autoRegion,grassVer Options or NULL.
#'
#' @return A character or logical.
#'
#' @details
#' .getGrassDir / .getReplace / .getGrassToR / .getOutVectClass / .getAutoRegion / .getGrassVer Get common arguments.
#' @keywords internal 
.getGrassDir <- function(grassDir) {
	
	if (is.null(grassDir)) {
		args <- get('args', pos=.fasterRaster)
		grassDir <- args$grassDir
	}
	
	grassDir
}

.getReplace <- function(replace) {
	
	if (is.null(replace)) {
		args <- get('args', pos=.fasterRaster)
		replace <- args$replace
	}
	replace
}

.getGrassToR <- function(grassToR) {
	
	if (is.null(grassToR)) {
		args <- get('args', pos=.fasterRaster)
		grassToR <- args$grassToR
	}
	grassToR
}

.getOutVectClass <- function(outVectClass) {
	
	if (is.null(outVectClass)) {
		args <- get('args', pos=.fasterRaster)
		outVectClass <- args$outVectClass
	}
	outVectClass
}

.getAutoRegion <- function(autoRegion) {

	if (is.null(autoRegion)) {
		args <- get('args', pos=.fasterRaster)
		autoRegion <- args$autoRegion
	}
	autoRegion
}

.getGrassVer <- function(grassVer=NULL) {

	if (is.null(grassVer)) {
		grassVer <- get('grassVer', pos=.fasterRaster)
	}
	grassVer
}
