library(omnibus)

results <- data.frame()

# for (rast in c('forest', 'chelsa')) {

	# if (rast == "forest") {
		# x <- fast('C:/Ecology/Research Data/GLAD Lab/Potapov et al 2020 Forest Height & Extent/2020/30N_090E.tif')
	# } else {
		# x <- fast('C:/Ecology/Research Data/CHELSA/chelsa_2.1_historical_1981_2010/CHELSA_bio1_1981-2010_V.2.1.tif')
	# }

	x <- forest_2000

	for (fun in c("mean", "mode")) {

		for (i in 0:10) {

			say(i, ' ', fun, post = 0)

			start <- Sys.time()
			if (i > 0) {

				y <- aggregate(x, fact = 2^i, fun = fun)
				writeRaster(y, 'C:/!scratch/y.tif', overwrite = TRUE)

			} else {
				writeRaster(x, 'C:/!scratch/y.tif', overwrite = TRUE)
			}

			stop <- Sys.time()

			runtime <- stop - start
			units <- attr(runtime, 'units')
			runtime <- as.vector(runtime)

			scalar <- if (units == 'secs') {
				1
			} else if (units == 'mins') {
				60
			} else if (units == 'hours') {
				3600
			} else if (units == 'days') {
				24 * 3600
			} else if (units == 'weeks') {
				7 * 24 * 3600
			}
			
			runtime_s <- scalar * runtime
			say(runtime_s)

			results <- rbind(
				results,
				data.frame(
					# rast = rast,
					i = i,
					pow = 2^i,
					fun = fun,
					sec = runtime_s
				)
			)

		}

	}

# }


