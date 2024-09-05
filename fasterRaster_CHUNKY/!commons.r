
	cores = fasterGetOptions('cores', 1),
	memory = fasterGetOptions('memory', 300),
	replace = fasterGetOptions('replace', FALSE),
	grassToR = fasterGetOptions('grassToR', TRUE),
	trimRast = fasterGetOptions('trimRast', TRUE),
	outVectClass = fasterGetOptions('outVectClass', 'SpatVector'),
	autoRegion = fasterGetOptions('autoRegion', TRUE),
	grassDir = fasterGetOptions('grassDir', NULL),
	...
	
	### commons v1
	##############

		### arguments
		.checkRastExists(replace=replace, rast=NULL, inRastName=NULL, outGrassName=outGrassName, ...)
		if (!missing(rast)) {
			if (!inherits(rast, 'character') & !inherits(rast, 'SpatRaster')) rast <- terra::rast(rast)
			inRastName <- .getInRastName(inRastName, rast=rast)
			.checkRastExists(replace=replace, rast=rast, inRastName=inRastName, outGrassName=NULL, ...)
		} else {
			rast <- inRastName <- NULL
		}

		if (!missing(vect)) {
			if (!inherits(vect, 'character') & !inherits(vect, 'SpatVector')) vect <- terra::vect(vect)
			inVectName <- .getInVectName(inVectName, vect=vect)
			.checkVectExists(replace=replace, vect=vect, inVectName=inVectName, outGrassName=NULL, ...)
		} else {
			vect <- inVectName <- NULL
		}

		### flags
		flags <- .getFlags(replace=replace)
		
		### restore
		# on.exit(.restoreLocation(), add=TRUE) # return to starting location
		if (autoRegion) on.exit(regionExt('*'), add=TRUE) # resize extent to encompass all spatials

		### ellipses and initialization arguments
		initsDots <- .getInitsDots(..., callingFx = 'xxxxxxxxxxxxxxxxx')
		inits <- initsDots$inits
		dots <- initsDots$dots

	###############
	### end commons

	### errors?

	### function-specific
	args <- list(
		cmd = 'r.XXXXX',
		input = inXXXXName,
		output = outGrassName,
		arg1 = XXXX,
		arg2 = XXXX,
		flags = flags,
		intern = TRUE
	)
	args <- c(args, dots)

	### initialize GRASS
	input <- do.call('startFaster', inits)

	### execute
	if (autoRegion) regionReshape(inXXXXName)
	do.call(rgrass::execGRASS, args=args)

	### export
	if (grassToR) {

		out <- fasterWriteRaster(outGrassName, paste0(tempfile(), '.tif'), overwrite=TRUE)
		out
		
	} else { invisible(TRUE) }

	if (grassToR) {

		out <- fasterWriteVector(outGrassName, paste0(tempfile(), '.gpkg'), flags='quiet')
		if (outVectClass == 'sf') out <- sf::st_as_sf(out)
		out

	} else { invisible(TRUE) }



