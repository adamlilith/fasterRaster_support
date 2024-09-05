#' Crop a raster to a smaller region
#'
#' Crop a raster to the extent of another raster or vector.\cr
#' IMPORTANT: In \code{GRASS}, cropping is done automatically when one imports a raster into an existing \code{GRASS} session that is smaller in extent than the raster. Each session has its own extent. So to crop a raster using \pkg{fasterRaster}, you have two options:\cr
#'
#' \itemize{
#' 	\item Crop a raster larger than extent of the active \code{GRASS} session to the extent the session:
#'	\itemize{
#'		\item This option can simultaneously crop and extend a raster. First, start a \code{GRASS} session using \code{\link[initGrass]} or using any \pkg{fasterRaster} function that uses \code{GRASS} by importing a raster or a vector. The extent of the raster or vector will set the extent of the region (called a "location" in \code{GRASS}).
#'		\item Export the raster to be cropped from \code{R} into the \code{GRASS} session using either \code{\link{fasterRast}}, or by using any other \pkg{fasterRaster} package that requires a raster as input or produces one as output. The raster will be cropped to the existing \code{GRASS} region. Note that if the raster is smaller (in any dimension) than the existing session extent, then it will be "padded" by having \code{NA} rows and columns added to it to fit the session's extent.
#'	}
#' 	\item Crop a raster using \code{fasterCropRast} (i.e., this function):
#' 	\itemize{
#'		\item Just run the function! Unlike the function
#'		\item \emph{Note that this function will remove any existing \code{GRASS} session and the rasters/vectors in it!} A warning will be shown. You can simultaneously crop and extend the raster with this function. If you do not want to restart your existing \code{GRASS} session, you can create another session using \code{\link{initGrass}}, and setting the \code{location} argument to anything but \code{'default'}. You can then import the raster back to \code{R} using \code{rgrass::read_RAST()}. To switch back to your first \code{GRASS} "location", use \code{\link{initGrass}} and set argument \code{location} to \code{'default'} (or whatever the name of your session/location was called).
#'	}
#' }
#'
#' @inheritParams .sharedArgs_rast
#' @inheritParams .sharedArgs_inRastName
#' @inheritParams .sharedArgs_replace
#' @inheritParams .sharedArgs_grassDir
#' @inheritParams .sharedArgs_grassToR
#'
#' @param template A \code{SpatRaster} to define the new extent of the raster. Note that this has to be an actual raster, not the quoted name of one in an existing \code{GRASS} session.
#' @param warn If \code{TRUE} (default), display a warning when using this function about removing any existing \code{GRASS} session.
#' @param ... Arguments to send to \code{\link{initGrass}}.
#' 
#' @return A \code{SpatRaster}. Also creates a raster in a new grass session named \code{inRastName}.
#' 
#' @seealso \code{\link{fasterExtendRast}} and \code{\link{fasterTrimRast}} in \pkg{fasterRaster}; \code{\link[terra]{crop}} and \code{\link[terra]{extend}} in \pkg{terra}; \href{https://grass.osgeo.org/grass82/manuals/g.region.html}{\code{r.clip}} and \href{https://grass.osgeo.org/grass82/manuals/g.clip.html}{\code{r.clip}} in \code{GRASS}
#' 
#' @examples man/examples/ex_fasterResizeRast.r
#'
#' @export

fasterCropRast <- function(
	rast,
	template,
	warn = TRUE,
	replace = FALSE,
	inRastName = NULL,
	grassToR = TRUE,
	grassDir = options()$grassDir,
	...
) {

	flags <- .getFlags(replace=replace)
	inRastName <- .getInRastName(inRastName, rast)
	
	# initialize GRASS
	if (inherits(template, c('SpatRaster', 'Raster'))) {
		inName <- 'TEMPTEMP_templateRast'
		input <- initGrass(rast=template, vect=NULL, inRastName=inName, inVectName=NULL, restartGrass=TRUE, warn=warn, replace=replace, grassDir=grassDir, ...)
	} else if (inherits(template, c('SpatVector', 'sf', 'Spatial'))) {
		inName <- 'TEMPTEMP_templateVect'
		input <- initGrass(rast=NULL, vect=template, inRastName=NULL, inVectName=inName, restartGrass=TRUE, warn=warn, replace=replace, grassDir=grassDir, ...)
	} else {
		stop('Argument "template" must be a raster or a vector\n(i.e., not the quoted name of one in an existing GRASS session).')
	}
		
	fasterRast(rast, inRastName=inRastName, warn=FALSE, replace=replace)
	fasterTrimRast(rast=inRastName, inRastName=inRastName, warn=FALSE, replace=replace, grassToR=FALSE, grassDir=grassDir)

	# return
	if (grassToR) {

		out <- rgrass::read_RAST(input, flags='quiet')
		names(out) <- input
		out

	}

}
