
# save GeoTIFF w names

.frloadall('c')
faster(verbose = TRUE)

madElev <- fastData('madElev')
elev <- fast(madElev)

createopt <- 'PROFILE=GeoTIFF,COMPRESS=LZW,PREDICTOR=2'
# createopt <- "PROFILE=GeoTIFF,COMPRESS=LZW,PREDICTOR=2"
# metaopt = "TIFFTAG_IMAGEDESCRIPTION=TesT"
metaopt = "IMAGEDESCRIPTION=TesT"
# metaopt = "TIFFTAG_MINSAMPLEVALUE=1"

rgrass::execGRASS('r.out.gdal', input = sources(elev), output = 'C:/!Scratch/elev.tif', format = 'GTiff', type = 'UInt16', createopt = createopt, metaopt = metaopt, flags = c('overwrite', 'c', 'verbose'))
rgrass::execGRASS('r.out.gdal', input = sources(elev), output = 'C:/!Scratch/elev.tif', format = 'GTiff', type = 'UInt16', createopt = createopt, flags = c('overwrite', 'c'))
rgrass::execGRASS('r.out.gdal', input = 'myraster', output = 'C:/!Scratch/herraster.tif', format = 'GTiff', type = 'UInt16', createopt = createopt, flags = c('overwrite', 'c'))

# names(rast('C:/!Scratch/elev.tif'))
names(rast('C:/!Scratch/myraster.tif'))
