#' Get raster or vector indicator
#'
#' Private. Used to determine if user wants rasters and/or vectors.
#'
#' @param rastOrVect Either 'rasters', 'vectors', or sometimes both.
#' @param n Maximum number of valid values for rastOrVect. If the length of rastOrVect is greater than "n", and error will be thrown.
#' @param nullOK If TRUE, then NULL or NA values for rasteOrVect are OK.
#'
#' @return Character vector.
#'
#' @keywords internal
.getRastOrVect <- function(rastOrVect, n, nullOK, ...) {

	if (length(rastOrVect) > n) stop(paste0('Argument "rastOrVect" can only have up to ', n, ' values.'))
	if (any(is.null(rastOrVect)) & !nullOK) {
		stop('Argument "rastOrVect" cannot be NULL.')
	} else if (any(is.null(rastOrVect) || is.na(rastOrVect)) & nullOK) {
		out <- NULL
	} else {

		out <- character()
		for (i in seq_along(rastOrVect)) {
			
			match <- pmatch(rastOrVect[i], c('rasters', 'vectors'))
			
			if (is.na(match)) {
				stop(paste0('No match found for value ', rastOrVect[i], ' in argument "rastOrVect".'))
			} else if (match == 1L) {
				out <- c(out, 'raster')
			} else if (match == 2L) {
				out <- c(out, 'vector')
			}
		
		}
		
		if (length(out) == 0L) {
			if (n == 1L) {
				stop('Argument "rastOrVect" must be "raster" or "vector".')
			} else {
				stop('Argument "rastOrVect" must be "raster" and/or "vector".')
			}
		}
	}
	
	out
	
}

# Indicates if x is a raster or vector in GRASS. Returns "raster" or "vector" or NA (not found) or error if ambiguous.
.isRastOrVect <- function(x, rastOrVect=NULL, errorNotFound=TRUE, errorAmbig=TRUE, ...) {

	# x				Name of a purported raster or vector in GRASS
	# rastOrVect	NULL, or "raster" and/or "vector"
	# errNotFound	If TRUE, throw an error if not found (otherwise returns NA)
	# errAmbig		If TRUE, throw an error if ambiguous (otherwise returns NA)
	# ...			Arguments like "temps" (Include temporary files?)

	if (inherits(x, 'SpatRaster')) {
		out <- 'raster'
	} else if (inherits(x, c('SpatVector', 'sf'))) {
		out <- 'vector'
	# neither SpatRaster, SpatVector, nor sf
	} else {

		rov <- if (is.null(rastOrVect)) { c('rasters', 'vectors')} else { rastOrVect }
		spatials <- fasterLs(rastOrVect = rov, ...)

		# nothing in session
		if (length(spatials) == 0L) {
			if (errorNotFound) stop('No object of this name was found the active GRASS session.')
			out <- NA
		} else {

			rastOrVect <- .getRastOrVect(rastOrVect, n=1, nullOK=TRUE)

			# get matching items
			matches <- if (is.null(rastOrVect)) {
				spatials[spatials %in% x]
			} else {
				spatials[names(spatials) %in% rastOrVect]
			}

			# get item type
			if (length(matches) == 0L) {
				if (errorNotFound) stop('No object of this name was found the active GRASS session.')
				out <- NA
			} else {
				type <- names(matches[matches %in% x])
				if (length(type) == 0L) {
					if (errorNotFound) stop('No object of this name was found the active GRASS session.')
					out <- NA
				} else if (length(type) > 1L) {
					if (errorAmbig) stop('More than one object with this name in the active GRASS session.')
					out <- NA
				} else {
					out <- type
				}
			}
			
		} # neither SpatRaster, SpatVector, nor sf
		
	}
		
	out

}

# Same as .isRastOrVect, but for multiple objects
.areRastOrVect <- function(x, rastOrVect=NULL, errorNotFound=TRUE, errorAmbig=TRUE, ...) {

	# x				Name(s) of purported raster(s) or vector(s) in GRASS
	# rastOrVect	Either "raster" and/or "vector"--one per value in x, or just NULL (one value)
	# errNotFound	If TRUE, throw an error if not found (otherwise returns NA)
	# errAmbig		If TRUE, throw an error if ambiguous (otherwise returns NA)
	# ...			Arguments like "temps" (Include temporary files?)

	rastOrVect <- .getRastOrVect(rastOrVect, n=Inf, nullOK=TRUE, ...)

	rov <- if (is.null(rastOrVect)) { c('rasters', 'vectors')} else { rastOrVect }
	spatials <- fasterLs(rastOrVect = rov, ...)

	# nothing in session
	if (length(spatials) == 0L) {
		if (errorNotFound) stop('No object of this name was found the active GRASS session.')
		out <- NA
	} else {

		rastOrVect <- .getRastOrVect(rastOrVect, n=1, nullOK=TRUE)

		# get matching items
		matches <- if (is.null(rastOrVect)) {
			spatials[spatials %in% x]
		} else {
			spatials[names(spatials) %in% rastOrVect]
		}

		# get item type
		if (length(matches) == 0L) {
			if (errorNotFound) stop('No object of this name was found the active GRASS session.')
			out <- NA
		} else {
			type <- names(matches[matches %in% x])
			if (length(type) == 0L) {
				if (errorNotFound) stop('No object of this name was found the active GRASS session.')
				out <- NA
			} else if (length(type) > 1L) {
				if (errorAmbig) stop('More than one object with this name in the active GRASS session.')
				out <- NA
			} else {
				out <- type
			}
		}
		
	} # neither SpatRaster, SpatVector, nor sf
	out

}
