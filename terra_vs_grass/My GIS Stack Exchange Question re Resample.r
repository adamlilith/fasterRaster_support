Comparing the results from the `resample()` function in R's `terra` package (version 1.7-29), and the `r.resamp.interp` GRASS GIS module (version 8.2), I find differences in how they apply bilinear interpolation. The differences are large!

Using `terra`:
```
library(geodata)
library(terra)

# get elevation for Madagascar
elev <- elevation_30s('MDG', path=getwd())

# crop to make this all faster
w <- 49.13
e <- 50.39
s <- -16.37
n <- -15.06
extent <- ext(c(w, e, s, n))
elev <- crop(elev, extent)
```

GRASS likes to report extents and resolutions in degrees-minutes-second format for unprojected coordinate systems, so to make this easier, I'm going to project the raster to an equal-area projection.

```
library(enmSdmX)
CRS <- getCRS('Madagascar Albers')
elev <- project(elev, CRS)
```

Now, resample to a coarser resolution:
```
template <- aggregate(elev, 4)
terra <- resample(elev, template, method='bilinear')
```

We'll call GRASS in R using `rgrass`:
```
library(rgrass)

# connect to GRASS (first argument is where GRASS is installed on my Windows system)
initGRASS('C:/Program Files/GRASS GIS 8.2', home=tempdir(), SG=elev, location='default', mapset='PERMANENT')

# export SpatRaster to GRASS
write_RAST(elev, 'elev')

# reshape GRASS region to match the template raster's resolution and extent
extent <- ext(template)
extent <- as.vector(extent)
w <- as.character(extent[1])
e <- as.character(extent[2])
s <- as.character(extent[3])
n <- as.character(extent[4])

rows <- nrow(template)
cols <- ncol(template)

execGRASS('g.region', rows=rows, cols=cols, n=n, s=s, e=e, w=w)

# resample
execGRASS('r.resamp.interp', input='elev', output='grass', method='bilinear')

# return to R
grass <- read_RAST('grass')
```

So these should be the same, correct?
```
terra

class       : SpatRaster 
dimensions  : 41, 38, 1  (nrow, ncol, nlyr)
resolution  : 3633.887, 3633.887  (x, y)
extent      : 687969, 826056.7, 1074146, 1223136  (xmin, xmax, ymin, ymax)
coord. ref. : Tananarive (Paris) / Laborde Grid 
source(s)   : memory
name        : MDG_elv_msk 
min value   :    7.294359 
max value   : 1115.549438

grass

class       : SpatRaster 
dimensions  : 41, 38, 1  (nrow, ncol, nlyr)
resolution  : 3633.887, 3633.887  (x, y)
extent      : 687969, 826056.7, 1074146, 1223136  (xmin, xmax, ymin, ymax)
coord. ref. : +proj=labrd +lat_0=-18.9 +lon_0=44.1 +azi=18.9 +k=0.9995 +x_0=400000 +y_0=800000 +ellps=intl +pm=paris +units=m +no_defs 
source      : file688441b57662.grd 
name        : file688441b57662 
min value   :         6.128405 
max value   :      1138.687195
```
Note the big differences in min/max values!

Differences seem biased slightly high at low values and biased low at high values:
```
combo <- c(terra, grass, delta)
combo <- as.data.frame(combo)
names(combo) <- c('terra', 'grass', 'delta')
plot(combo$terra, combo$delta)
```

A bit of the difference lies in the fact that GRASS drops some cells that `terra` does not. From the GRASS manual page for `r.resamp.interp`: "Note that for bilinear, bicubic and lanczos interpolation, cells of the output raster that cannot be bounded by the appropriate number of input cell centers are set to NULL (NULL propagation). This could occur due to the input cells being outside the current region, being NULL or MASKed."

But the cells GRASS drops are not responsible for most of the differences (red is cells dropped by GRASS but not be `terra`):
```
par(mfrow=c(1, 2))
plot(elev, main='Original')

plot(terra, col='red', legend=FALSE)
plot(grass, col='yellow', legend=FALSE, add=TRUE)
```

There are several ways to do bilinear interpolation; I'd assume they'd be equivalent, with allowances for rounding error since some are approximations.  However, the differences I get between `terra` and GRASS are much bigger than is reasonable to expect for rounding approximation.

Why do `terra` and GRASS yield such different rasters when using what is presumably the same interpolation method?

```
execGRASS('r.resamp.stats', input='elev', output='agg', method='average')
execGRASS('r.resamp.interp', input='agg', output='grassAgg', method='mean')
grassAgg <- read_RAST('grassAgg')

```

