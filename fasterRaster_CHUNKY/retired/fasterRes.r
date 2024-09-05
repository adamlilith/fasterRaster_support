#' Spatial extent of one or more rasters in a GRASS session
#'
#' This function returns the spatial resolution of one or more rasters in the active \code{GRASS} session.
#'
#' @param rast The name of one or more rasters already in the active \code{GRASS} session, or \code{NULL} (default), in which case the resolutions of each raster in the session are printed.
#' 
#' @return A \code{data.frame}.
#'
#' @seealso \code{\link{fasterExt}} and \code{\link{fasterInfoRast}} in \pkg{fasterRaster}; \code{\link[terra]{res}} in the \code{\link[terra]{terra}} package; \href{https://grass.osgeo.org/grass82/manuals/r.info.html}{\code{r.info}} in \code{GRASS}
#'
#' @example man/examples/ex_fasterInfo.r
#'
#' @export
fasterRes <- function(rast = NULL) {

	out <- fasterInfo(rast, 'rasters')
	
	if (is.null(rast)) rast <- fasterLs('rasters')

	if (length(rast) > 0L) {

		out <- data.frame()
		for (r in rast) {

			suppressMessages(info <- rgrass::execGRASS('r.info', flags='g', map=r, intern=TRUE, Sys_show.output.on.console=FALSE, echoCmd=FALSE))
		
			nsres <- info[grepl(info, pattern='nsres')]
			nsres <- strsplit(nsres, ' ')[[1]]
			nsres <- nsres[grepl(nsres, pattern='nsres')]
			nsres <- strsplit(nsres, 'nsres=')[[1]][2L]
			nsres <- substr(nsres, 1, nchar(nsres) - 2)
			nsres <- as.numeric(nsres)
		
			ewres <- info[grepl(info, pattern='ewres')]
			ewres <- strsplit(ewres, ' ')[[1]]
			ewres <- ewres[grepl(ewres, pattern='ewres')]
			ewres <- strsplit(ewres, 'ewres=')[[1]][2L]
			ewres <- substr(ewres, 1, nchar(ewres) - 2)
			ewres <- as.numeric(ewres)
			
			out <- rbind(
				out,
				data.frame(
					raster = r,
					ewres = ewres,
					nsres = nsres
				)
			)
			
		}
		
	} else {
		warning('No rasters were found in the active GRASS session.')
		out <- NULL
	}
		
	out

}
