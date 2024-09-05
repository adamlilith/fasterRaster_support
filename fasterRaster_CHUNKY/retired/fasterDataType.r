#' Data type of values in one or more rasters in an active GRASS session
#'
#' Data type of values stored in one or more rasters in an existing \code{GRASS} session.
#'
#' @param rast A character vector with the names of the rasters.
#'
#' @return A \code{data.frame}. The columns indicate the raster's name in \code{GRASS}, the data type (column \code{datatype}, the data type string appropriate for saving this type of raster with \href{https://grass.osgeo.org/grass82/manuals/r.out.gdal.html}{r.out/gdal} or with \code{\link{fasterWriteRaster}} (column \code{grass}), and the data type value appropriate for saving the raster with \code{\link[terra[{writeRaster}},  \code{\link{writeRaster4}}, or \code{\link{writeRaster8}} (column \code{terra}).
#'
#' @example man/examples/ex_fasterInfo.r
#'
#' @export

fasterDataType <- function(rast = NULL) {

	if (is.null(rast)) rast <- fasterLs('rasters')
	
	# we have rasters!
	if (length(rast) != 0L) {
		
		out <- data.frame()
		for (i in seq_along(rast)) {
		
			r <- rast[i]
			suppressMessages(info <- rgrass::execGRASS('r.info', map=r, flags=c('quiet', 'g'), intern=TRUE, Sys_show.output.on.console=FALSE, echoCmd=FALSE))
		
			info <- info[grepl(info, pattern='datatype=')]
			info <- sub(info, pattern='datatype=', replacement='')
			
			if (info == 'CELL') {
				terra <- 'INT4S'
				grass <- 'Int32'
			} else if (info == 'FCELL') {
				terra <- 'FLT4S'
				grass <- 'Float32'
			} else if (info == 'DCELL') {
				terra <- 'FLT8S'
				grass <- 'Float64'
			}
			
			out <- rbind(
				out,
				data.frame(
					raster = r,
					datatype = info,
					grass = grass,
					terra = terra
				),
				make.row.names = FALSE
			)
		
		} # next raster
	
	# no rasters
	} else {
		out <- NULL
	}

	out

}
