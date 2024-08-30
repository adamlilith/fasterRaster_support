REM Batch file for compiling help file PDFs
REM This file is useful for catching the vague "comma" error in R CMD check()

setlocal enabledelayedexpansion REM Necessary for variables in a loop

mkdir "C:/!Scratch"
cd "C:/!Scratch"

set "docs_directory=C:/ecology/Drive/R/fasterRaster/man"

REM Loop through all files in the directory

echo off
for %%f in ("%docs_directory%\*.*") do (
    REM Check if the file is a .Rd file (adjust the extension as needed)
    if /i "%%~xf"==".Rd" (
        REM Run R CMD Rd2pdf on the file
		echo "%%f"
        R CMD Rd2pdf "%%f"
    )
)

echo on
pause
