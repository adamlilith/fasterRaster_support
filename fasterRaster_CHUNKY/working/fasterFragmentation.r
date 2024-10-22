#' Fragmentation indices for a raster (i.e., forest fragmentation)
#'
#' This function uses multiple CPU cores to speed calculation of a set of fragmentation indices as per Riitters, K., J. Wickham, \pkg{R}. O'Neill, B. Jones, and E. Smith. 2000. Global-scale patterns of forest fragmentation. Conservation Ecology 4:3. URL: <https://www.jstor.org/stable/26271763>. (Also note the erratum to the paper on their classification scheme at <https://www.ecologyandsociety.org/vol4/iss2/art3/errata/january26.2001.html>). Unlike many functions in the \pkg{fasterRaster} package this function does \emph{not} use \code{GRASS} but rather multiple cores. It is a wrapper for \code{\link[fasterRaster]{fasterFocal}}.
#' @param rast A \code{SpatRaster} with binary values (1 or 0 or \code{NA}).
#' @param size Integer, number of cells wide and high of the window used to calculate fragmentation. This must be an odd integer (default is 3).
#' @param pad Logical, if \code{TRUE} then add virtual rows and columns around the raster so that there are no edge effects. Default is \code{FALSE}.
#' @param calcDensity Logical, if \code{TRUE} (default) then calculate density raster.
#' @param calcConnect Logical, if \code{TRUE} (default) then calculate connectivity raster.
#' @param calcClass Logical, if \code{TRUE} (default) then calculate classification raster. Note that to calculate the classification raster the density and connectivity rasters must also be calculated (\code{calcDensity} and \code{calcConnect} should both be \code{TRUE}). If they are not then the will be forced to \code{TRUE} with a warning.
#' @param na.rm Logical, if \code{FALSE} (default) then \code{NA} cells count as part of the area potentially occupied in a window (i.e., they count in the denominator when calculating density and they are counted as potential links in the connectance calculations if a neighboring cell has a value of 1). If \code{FALSE} then areas that border \code{NA} cells could still be classified as "interior" or otherwise have less apparent fragmentation if the occupied cells are fully surrounded by other occupied cells (except for the \code{NA} cells).
#' @param undet Character. When classifying this defines what is done with "undetermined" cases (when density is >= 0.6 and density == connectivity). Possible values include (partial matching of strings is used):
#' \itemize{
#' 	\item \code{undetermined}: Undetermined cases will be assigned a value of 5 (which is not assigned to any other case; default).
#' 	\item \code{perforated}: Undetermined cases will be assigned a value of 3 ("perforated").
#' 	\item \code{edge}: Undetermined cases will be assigned a value of 4 ("edge").
#' 	\item \code{random}: Undetermined cases will be assigned a value of 3 or 4 at random ("perforated" or "edge").
#' }
#' @param cores Integer >0, number of CPU cores to use to calculate the focal function (default is 2).
#' @param verbose Logical. If \code{TRUE} then print progress indicators. Default is \code{FALSE}.
#' @param ... Additional arguments to send to \code{\link[fasterRaster]{fragmentation}} (which is used when only one core is used).
#'
#' @return A raster stack with three rasters: a fragmentation classification (named \code{class}), the density of "1" pixels in the window (named \code{density}--called "pf" in Riitter et al. 2000), and a connectivity raster (conditional probability a cell with a value of 1 has a value that is also 1; named \code{connect}--called "pff" in Riitter et al. 2000).
#' The density and connectivity rasters have values in the range [0, 1], but the classification raster has coded values (from the erratum to Ritter et al. (2000)):
#' \itemize{
#' 	\item \code{NA}: \code{NA}
#' 	\item \code{0}: No forest (or whatever is being evaluated)
#'	\item \code{1}: patch (\code{pf} < 0.4)
#'	\item \code{2}: transitional (0.4 <= \code{pf} < 0.6)
#'	\item \code{3}: perforated (\code{pf} >= 0.6 & \code{pf - pff} > 0)
#'	\item \code{4}: edge (\code{pf} >= 0.6 & \code{pf - pff} < 0)
#'	\item \code{5}: undetermined (\code{pf} >= 0.6 & \code{pf == pff})
#'	\item \code{6}: interior (\code{pf} == 1)
#' }
#'
#' @seealso \code{\link[fasterRaster]{fragmentation}}
#'
#' @examples /man/examples/ex_fasterFragmentation.r
#'
#' @export

fasterFragmentation <- function(
	rast,
	size = 3,
	pad = FALSE,
	calcDensity = TRUE,
	calcConnect = TRUE,
	calcClass = TRUE,
	na.rm = FALSE,
	undet = 'undetermined',
	cores = 2,
	verbose = FALSE,
	...
) {

	if (size %% 2 == 0 | size < 3) stop('Argument "size" to function fragmentation() must be an odd integer >= 3.')
	if (calcClass & (!calcDensity | !calcConnect)) {
		warning('Forcing "calcDensity" and "calcConnect" in function "fragmentation()" to be TRUE since "calcClass" is TRUE.')
	}

	if (inherits(rast, 'SpatRaster')) rast <- terra::rast(rast)

	# number of cores
	cores <- .getCores(rast = rast, cores = cores)	
	
	### single core
	if (cores == 1) {

		if (verbose) {
			cat('Using single-core implementation...')
			flush.console()
		}
		
		out <- fasterRaster::fragmentation(
			rast=rast,
			size=size,
			calcDensity=calcDensity,
			calcConnect=calcConnect,
			calcClass=calcClass,
			na.rm=na.rm,
			...
		)

	### multi-core
	} else {

		# density
		if (calcDensity | calcClass) {

			if (verbose) {
				cat('\nCalculating density...')
				flush.console()
			}

			fragDensity <- fasterFocal(rast=rast, w=size, fun=.fragDensity, na.rm=na.rm, cores=cores, filename='', pad=pad, NAonly=FALSE, progress=verbose)

			names(fragDensity) <- 'density'

		}

		# connectivity
		if (calcConnect | calcClass) {

			if (verbose) {
				cat('\nCalculating connectivity...')
				flush.console()
			}

			fragConnect <- fasterFocal(rast=rast, w=size, fun=.fragConnect, na.rm=na.rm, cores=cores, filename='', pad=pad, padValue=padValue, NAonly=FALSE, progress=verbose)

			names(fragConnect) <- 'connect'

		}

		# fragmentation class
		if (calcClass) {

			if (verbose) {
				cat('\nCalculating fragmentation class...')
				flush.console()
			}

			densConnect <- c(fragDensity, fragConnect)

			fx <- function(x, ...) calc(x, fun=fasterRaster:::.fragClassify, ...)

			# multi-core
			raster::beginCluster(cores)
			on.exit(raster::endCluster())

			fragClass <- raster::clusterR(densConnect, fun=fx, args=list(undet=undet))

			raster::endCluster()

			names(fragClass) <- 'class'

		}

		# collate output
		out <- if (calcDensity & !calcConnect & !calcClass) {
			fragDensity
		} else if (!calcDensity & calcConnect & !calcClass) {
			fragConnect
		} else if (calcDensity & calcConnect & !calcClass) {
			c(fragDensity, fragConnect)
		} else if (calcClass) {
			c(fragClass, fragDensity, fragConnect)
		}

	} # multi-core

	out

}
