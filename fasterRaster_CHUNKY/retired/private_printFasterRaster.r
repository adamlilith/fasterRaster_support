#' Display all objects and their values in the .fasterRaster environment
#'
#' For developer only.
#'
#' @return All objects and their values in the .fasterRaster environment.
#'
#' @keywords internal

.FR <- function() {

	objs <- ls(.fasterRaster)
	for (obj in objs) {
	
		cat(obj, '\n')
		x <- get(obj, pos=.fasterRaster)
		print(x)
		cat('\n')
	
	}

}
