#' Centroids
#'
#' @description Locate centroids of *subgeometries* of a "polygons" `GVector`. 
#'
#' @param x A "polygons" `GVector`.
#'
#' @returns A "points" `GVector`.
#'
#' @example man/examples/ex_centroids.r
#'
#' @seealso [terra::centroids()]; [as.points()]
#'
#' @exportMethod centroids
methods::setMethod(
	f = "centroids",
	signature = c(x = "GVector"),
	definition = function(x) {
	
	if (geomtype(x, grass = TRUE) != "area") stop("The centroids() function can only operate on polygon GVectors.")

	.locationRestore(x)

	src <- .makeSourceName("centroids_v_centroids", "vector")
	rgrass::execGRASS(
		cmd = "v.to.points",
		input = sources(x),
		type = "line",
		output = src,
		type = "centroid",
		flags = c(.quiet(), "overwrite")
	)

	.makeGVector(src, table = x)
	
	} # EOF
)
