#' Get arguments from ... to pass to initGrass
#'
#' Get arguments from \code{...} to pass to initGrass. This function is useful for passing arguments to two or more functions within a wrapper using ellipses.
#'
#' @param ... Arguments which may or may not be passed to \code{\link{initGrass}}.
#' @param list A named list (of arguments).
#' @param initGrassOnly If \code{TRUE} (default), return arguments to send to \code{\link{initGrass}}. If \code{FALSE}, return all other arguments.
#'
#' @return Either \code{NULL} or a named list.
#'
#' @keywords internal

.getInitGrassArgs <- function(..., list = NULL, initGrassOnly = TRUE) {

	initGrassArgs <- names(formals(initGrass))
	ells <- list(...)
	ells <- c(ells, list)
	
	out <- if (initGrassOnly) {
		ells[names(ells) %in% initGrassArgs]
	} else {
		ells[!(names(ells) %in% initGrassArgs)]
	}
	
	out

}
