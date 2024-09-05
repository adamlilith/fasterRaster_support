#' Set GRASS directory for fasterRaster functions
#' 
#' Most functions in \pkg{fasterRaster} use the \code{grassDir} option for specifying where \pkg{GRASS} is installed. However, defining this argument every time can be cumbersome if you are using a lot of \code{fasterRaster} functions. Instead, you can define \code{grassDir} just once in \code{fasterOptions}, and subsequent calls to \pkg{fasterRaster} functions will automatically use that directory.
#'
#' @param ... Option names to retrieve values or \code{[key]=[value]} pairs to set options.
#'
#' @section Supported options:
#' The following options are supported
#' \itemize{
#'  \item{\code{grassDir}} (\code{character}): Name of the directory in which GRASS is installed. Example for a Windows system: \code{'C:/Program Files/GRASS GIS 8.2'}. Example for a Mac: \code{"/Applications/GRASS-8.2.app/Contents/Resources"}. The default value is \code{NULL}, in which case functions will try to find the inatll directory automatically (and usually take a long time and/or fail).
#' }
#'
#' @examples
#'
#' grassDir <- 'C:/Program Files/GRASS GIS 8.2'
#' fasterOptions(grassDir = grassDir)
#'
#' @export
fasterOptions <- function(...) {
 
	# protect against the use of reserved words.
	settings::stop_if_reserved(...)
	.fasterOptions(...)

}

#' Check grassDir argument
#' @keywords internal
.grassDirChecker <- function(x) {

	x <- if (!is.null(x)) {
		if (is.character(x)) {
			x
		} else {
			stop('Argument grassDir must be a character string indicating the full path of where GRASS is installed.')
		}
	} else {
		x
	}

	x
	
}

#

#' Set initial options
#' @keywords internal
.fasterOptions <- settings::options_manager(
	grassDir = NULL,
	.allowed = list(
		grassDir = .grassDirChecker
	)
)

#' Reset global options for fasterRaster
#' @export
fasterOptionsReset <- function() settings::reset(.fasterOptions)
