devtools::load_all('C:/Ecology/R/fasterRaster')
library(rgrass)
library(terra)

faster(grassDir = 'C:/Program Files/GRASS GIS 8.3')

# terra
basins_terra <- vect('C:/Ecology/Research Data/Watershed Basins in Southeast Asia (FAO)/hydrobasins_asia.gpkg')
select_terra <- basins_terra[basins_terra$MAJ_NAME == 'Mekong' & basins_terra$SUB_NAME == 'Nam Loi']
select_terra

basins_grass <- fast('C:/Ecology/Research Data/Watershed Basins in Southeast Asia (FAO)/hydrobasins_asia.gpkg', correct = TRUE)
basins_grass
select_grass <- select_grass[select_grass$MAJ_NAME == 'Mekong' & select_grass$SUB_NAME == 'Nam Loi']
select_grass

i <- x$MAJ_NAME == 'Mekong' & x$SUB_NAME == 'Nam Loi'

# plot(select_terra)

# GRASS
ch <- fastData('madChelsa')
ch <- fast(ch)
write_VECT(basins_terra, vname = 'grass')
basins_grass <- .makeGVector('grass')
.region(basins_grass)

where <- "SUB_NAME = 'Nam Loi'"
where <- "cat = 481"
where <- "cat == 481"
execGRASS('v.extract', input = 'grass', output = 'select', where = where, type = 'boundary', flags = 'overwrite')
execGRASS('v.extract', input = 'grass', output = 'select', cats = '481', type = 'boundary', flags = 'overwrite')
.exists('select')

.makeGVector('select')

select_grass <- read_VECT('select', type = 'area')
select_grass

par(mfrow = c(1, 2))
plot(select_terra, main = 'terra')
plot(select_grass, main = 'grass')
