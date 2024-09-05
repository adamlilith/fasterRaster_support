# fasterRaster_support
Files for developers of the **fasterRaster** package

If you find an issue that pertains to how a **fasterRaster** function works, please file an <a href = "https://github.com/adamlilith/fasterRaster/issues">issue</a> there.

These scripts are made for developers of **fasterRaster**. Most users of **fasterRaster** will not find these helpful, nor are they needed to use the package.

 Key scripts include:
 * `dev_setup.r`: Script to run setup for writing an testing code manually.
* `test_examples.r`: Tests all examples. This is needed because most examples are wrapped in `grassStarted()` which will be `FALSE` in automated CRAN checks because the system used to check packages will not have **GRASS** installed, and would need a user to point **fasterRaster** to the install folder.

~ Adam