#' Resample a categorical raster to a different resolution
#'
#' This function resamples a categorical raster to a different resolution using the "nearest-neighbor" rule to assign categories to new cells.
#'
#' @inheritParams .sharedArgs_rast
#' @inheritParams .sharedArgs_replace
#' @inheritParams .sharedArgs_inRastName
#' @inheritParams .sharedArgs_grassDir
#' @inheritParams .sharedArgs_grassToR
#' @inheritParams .sharedArgs_outGrassName
#' @inheritParams .sharedArgs_inits
#' @param template A \code{SpatRaster}, the name of a raster already in an existing \code{GRASS} session, or \code{NULL} (default)--for use with user-defined resolutions (\code{ewres} and \code{nsres}). The resolution of this raster is used to resample the raster in \code{rast}.
#' @param ewres,nsres Resolution (in map units) in the east-west and north-south directions. Ignored if \code{template} is not \code{NULL}.
#'
#' @return A \code{SpatRaster}. In addition, a raster is created in the active \code{GRASS} session.
#'
#' @example man/examples/ex_fasterResampleCatRast.r
#'
#' @seealso \code{\link{fasterResampleContRast}} in \pkg{fasterRaster}; \code{\link[terra]{resample}} in \pkg{terra}; \href{https://grass.osgeo.org/grass82/manuals/r.resample.html}{\code{r.resample}} in \code{GRASS}
#'
#' @export

fasterResampleCatRast <- function(
	rast,
	template = NULL,
	ewres = NULL,
	nsres = NULL,
	replace = FALSE,
	inRastName = NULL,
	outGrassName = 'resampledCatRast',
	grassToR = TRUE,
	grassDir = options()$grassDir,
	inits = NULL
) {

	flags <- .getFlags(replace=replace)
	thisFlags <- c(flags, c('a'))
	
	# initialize GRASS
	inRastName <- .getInRastName(inRastName, rast)
	if (is.null(inits)) inits <- list()
	inits <- c(inits, list(rast=rast, vect=NULL, inRastName=inRastName, inVectName=NULL, replace=replace, grassDir=grassDir))
	input <- do.call('initGrass', inits)
	
	# resolution from user
	if (is.null(template)) {

		ewres <- as.character(ewres)
		nsres <- as.character(nsres)
		rgrass::execGRASS('g.region', ewres=ewres, nsres=nsres, flags=thisFlags)

	} else {

		# template is already in GRASS
		if (inherits(template, 'character')) {
		
			rgrass::execGRASS('g.region', input=template, flags=thisFlags)
			ress <- fasterRes(template)
			ewres <- as.character(ress$ewres)
			nsres <- as.character(ress$nsres)
		
		# resolution from raster in R (not necessarily also in GRASS)
		} else {

			resol <- terra::res(template)
			ewres <- as.character(resol[1L])
			nsres <- as.character(resol[2L])
			
		}
		
		rgrass::execGRASS('g.region', ewres=ewres, nsres=nsres, flags=thisFlags)
			
	}
		
	rgrass::execGRASS('r.resample', input=inRastName, output=outGrassName, flags=flags)
	
	# resize region to encompass all objects
	success <- regionResize()
	
	# return
	if (grassToR) {

		out <- fasterWriteRaster(outGrassName, paste0(tempfile(), '.tif'), overwrite=TRUE)
		out

	}

}
