#' Remember/restore session information (location, region) and reshape region
#'
#' This function is private. It saves the current location, mapset, and region to the .fasterRaster environment.
#'
#' @return TRUE (session information saved, region saved, region resized) or FALSE (not done).  It will not be saved if .fasterRaster:::sessionStarted is FALSE.  Session and region information saved to .fasterRaster environment.
#'
#' @keywords internal

.remember <- function() {

	if (get('sessionStarted', pos=.fasterRaster)) {
		
		### session
		###########

			info <- rgrass::execGRASS('g.gisenv', intern=TRUE)
			
			dir <- sub(info[1L], pattern='GISDBASE=\'', replacement='')
			dir <- sub(dir, pattern='\';', replacement='')
			
			location <- sub(info[2L], pattern='LOCATION_NAME=\'', replacement='')
			location <- sub(location, pattern='\';', replacement='')
			
			mapset <- sub(info[3L], pattern='MAPSET=\'', replacement='')
			mapset <- sub(mapset, pattern='\';', replacement='')
			
			session <- list(
				dir = dir,
				location = location,
				mapset = mapset
			)
			
			assign('session', session, pos=.fasterRaster)
			
		### region
		##########
			
			info <- rgrass::execGRASS('g.region', flags=c('p', 'u'), intern=TRUE)

			# extent
			n <- info[grepl('north:', info)]
			s <- info[grepl('south:', info)]
			e <- info[grepl('east:', info)]
			w <- info[grepl('west:', info)]

			n <- sub(n, pattern='north:', replacement='')
			s <- sub(s, pattern='south:', replacement='')
			e <- sub(e, pattern='east:', replacement='')
			w <- sub(w, pattern='west:', replacement='')

			n <- trimws(n)
			s <- trimws(s)
			e <- trimws(e)
			w <- trimws(w)

			n <- as.numeric(n)
			s <- as.numeric(s)
			e <- as.numeric(e)
			w <- as.numeric(w)

			# dimensions
			rows <- info[grepl('rows:', info)]
			cols <- info[grepl('cols:', info)]

			rows <- sub(rows, pattern='rows:', replacement='')
			cols <- sub(cols, pattern='cols:', replacement='')

			rows <- as.numeric(rows)
			cols <- as.numeric(cols)

			# resolution
			ewres <- info[grepl('ewres:', info)]
			nsres <- info[grepl('nsres:', info)]

			ewres <- sub(ewres, pattern='ewres:', replacement='')
			nsres <- sub(nsres, pattern='nsres:', replacement='')
			
			ewres <- trimws(ewres)
			nsres <- trimws(nsres)

			ewres <- as.numeric(ewres)
			nsres <- as.numeric(nsres)
			
			region <- list(
				n = n,
				s = s,
				e = e,
				w = w,
				rows = rows,
				cols = cols,
				ewres = ewres,
				nres = nsres
			)
			
			assign('region', region, pos=.fasterRaster)
			
			invisible(TRUE)

	} else {
		invisible(FALSE)
	}
	
}

#' Revert to previous GRASS location (usually "default")
.restoreLocation <- function(location = NULL) {

	if (.getSessionStarted()) {

		location <- if (!is.null(location)) { location } else { .getLocation() }
		mapset <- .getMapset()

		if (!is.na(location) & !is.na(mapset)) {

			success <- rgrass::execGRASS('g.mapset', mapset=mapset, location=location, flags='quiet', intern=TRUE, ignore.stderr=TRUE)
			invisible(TRUE)
		
		} else {
			invisible(FALSE)
		}
		
	} else {
		invisible(FALSE)
	}

}

#' Revert to previous GRASS region
.saveRegion <- function() {

	if (.getSessionStarted()) {
		
		extent <- regionExt()
		dim <- regionDim()
		res <- regionRes()
		
		region <- list(
			n = extent[4L],
			s = extent[3L],
			e = extent[2L],
			w = extent[1L],
			rows = dim[1L],
			cols = dim[2L],
			ewres = res[1L],
			nres = res[2L]
		)
		
		assign('region', region, pos=.fasterRaster)
		invisible(as.logical(NA))
		
	} else {
		invisible(FALSE)
	}

}

#' Resize region to encompass all spatials in the location
.resizeRegionToAll <- function() {

	if (.getSessionStarted()) {

		spatials <- fasterLs()
		if (length(spatials) > 0L) {
		
			rastOrVect <- names(spatials)
			regionResize(rastOrVect=rastOrVect)
			invisible(TRUE)
			
		} else {
			invisible(FALSE)
		}
		
	} else {
		invisible(FALSE)
	}

}
