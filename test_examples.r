### TEST fasterRaster EXAMPLE FILES
### source('C:/Ecology/R/fasterRaster_support/test_examples.r')
###
### This script cycles through each help file and executes the code. It is useful because most help files are wrapped in an "if (grassStarted())" test, which circumvents the usual example checking done with check().

### setup
#########

rm(list=ls())
drive_ <- 'C:/Ecology/'
# drive_ <- "E:/Adam/"

# Start checking from this file (assume they are listed in alphabetical order by file name)
# startFromFile_ <- NULL # start from 1st
startFromFile_ <- 'ex_interpSplines.r'

library(data.table)
library(sf)
library(terra)

if (any(search() == "fasterRaster")) detach("fasterRaster")

fr <- paste0(drive, '/R/fasterRaster')
devtools::load_all(fr)
.backdoor()

# initiate GRASS
faster(verbose = FALSE)
dummy <- fastData('madElev')
dummy <- fast(dummy)

### test help files
###################

# list files and remove those already checked
exampleFiles_ <- omnibus::listFiles("./man/examples")
if (!is.null(startFromFile_)) {

	startFromIndex_ <- which(basename(exampleFiles_) == startFromFile_)
	if (length(startFromIndex_) > 0) exampleFiles_ <- exampleFiles_[(startFromIndex_):length(exampleFiles_)]

}

# cycle through each file
for (COUNT in seq_along(exampleFiles_)) {

	omnibus::say(exampleFiles_[COUNT], level = 1)

	codeIn_ <- readLines(exampleFiles_[COUNT])
	if (any(grepl(codeIn_, pattern = "locationRestore"))) codeIn_ <- codeIn_[!grepl(codeIn_, pattern = "locationRestore")]

	omnibus::dirCreate(paste0("C:/!Scratch/fasterRaster_test"))
	writeLines(codeIn_, paste0("C:/!Scratch/fasterRaster_test/", basename(exampleFiles_[COUNT])))
	
	source(paste0("C:/!Scratch/fasterRaster_test/", basename(exampleFiles_[COUNT])), echo = TRUE)
	flush.console()

}
