

initGrass(rast=madElevSmall)

execGRASS('r.mapcalc', expression = 'madElevSmall = double(madElevSmall)', flags=flags)

execGRASS('r.mapcalc', expression = 'squares = madElevSmall^2')

	squares <- madElevSmall^2
	grass <- read_RAST('squares')

	df <- as.data.frame(c(squares, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])

execGRASS('r.neighbors', size=3, method='sum', input='squares', output='sumOfSquares', flags=flags)

	sumOfSquares <- focal(squares, w=3, 'sum', na.rm=TRUE)
	grass <- read_RAST('sumOfSquares')

	df <- as.data.frame(c(sumOfSquares, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])


execGRASS('r.neighbors', size=3, method='sum', input='madElevSmall', output='sums', flags=flags)

	sums <- focal(madElevSmall, w=3, 'sum', na.rm=TRUE)
	grass <- read_RAST('sums')

	df <- as.data.frame(c(sums, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])


execGRASS('r.mapcalc', expression = 'squareSums = sums^2', flags=flags)

	squareSums <- sums^2
	grass <- read_RAST('squareSums')

	df <- as.data.frame(c(squareSums, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])

execGRASS('r.mapcalc', expression = 'onesMask = if(isnull(madElevSmall), null(), double(1))', flags=flags)

	onesMask <- madElevSmall * 0 + 1
	grass <- read_RAST('onesMask')

	df <- as.data.frame(c(onesMask, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])


execGRASS('r.neighbors', size=3, method='sum', input='onesMask', output='n', flags=flags)

	n <- focal(onesMask, 3, 'sum', na.rm=TRUE)
	grass <- read_RAST('n')

	df <- as.data.frame(c(n, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])

execGRASS('r.mapcalc', expression = 'numeratorRight = squareSums / n', flags=flags)

	# different here!
	numeratorRight <- squareSums / n
	grass <- read_RAST('numeratorRight')

	df <- as.data.frame(c(numeratorRight, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])

execGRASS('r.mapcalc', expression = 'numerator = sumOfSquares - numeratorRight', flags=flags)

	# different here!
	numerator <- sumOfSquares - numeratorRight
	grass <- read_RAST('numerator')

	df <- as.data.frame(c(numerator, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])

execGRASS('r.mapcalc', expression = 'denominator = n - 1', flags=flags)

	denominator <- n - 1
	grass <- read_RAST('denominator')

	df <- as.data.frame(c(denominator, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])

execGRASS('r.mapcalc', expression = 'sd = sqrt(numerator / denominator)', flags=flags)

	terra <- sqrt(numerator / denominator)
	grass <- read_RAST('sd')

	df <- as.data.frame(c(terra, grass))
	sum(!complete.cases(df))
	range(df[ , 1] - df[ , 2])

