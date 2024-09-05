
library(terra)
madElev <- fasterData('madElev')

madElevSqrt <- fasterCalc(madElev, sqrt, cores=2)
oldPar <- par(mfrow=c(1, 2))
plot(madElev)
plot(madElevSqrt)
par(oldPar)
