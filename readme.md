# Goals of Care Site Reports

## Prerequisites

### LaTeX
For Windows users MikTex is suggested [https://miktex.org/](https://miktex.org/)

### R
Home Page [https://cran.r-project.org/](https://cran.r-project.org/)

Optionally, use RStudio to get a GUI. [https://www.rstudio.com/](https://www.rstudio.com/)

### R Packages
* ggplot2
* ggthemes
* tidyr
* dplyr
* knitr

Included under lib/ is an installer script that will attempt to download, build, and install required packages: [required-packages.r](lib/required-packages.r)

## Use

1. Gather input data and export as an .rdata file in the input/ directory.
    * Default behavior is to use input/clc.rdata
    * The report generation does *not* currently accomodate concurrent use.

1. From the project root directory run the following commands

  * Windows Powershell
    ```
    # Run install script to make sure required packages are installed.
    Rscript lib\required-packages.r

    # Check that input data has expected headers
    #   The result should be the printed statement: `
    #   Header check:
    #   Expected: 12 encountered: 12
    Rscript lib\check_input.r
    ```

  * Windows CMD
    ```
    echo Run install script to make sure required packages are installed.
    Rscript lib\required-packages.r

    REM Check that input data has expected headers
    Rscript lib\check_input.r
    ```

  * Linux/OSX:

    ```
    # Run install script to make sure required packages are installed.
    Rscript lib/required-packages.r

    # Check that input data has expected headers
    Rscript lib/check_input.r

    # Filter the input data
    Rscript lib/filter_input.r

    # Calculate performance measure
    Rscript lib/calc_perf_measures.r

    # Manual PDF compile from CLI
    cd lib/clc_memo
    R CMD Sweave --clean report_1.Rnw
    pdflatex -output-directory=../../reports report_1.tex

    # Clean up and return to root project directory
    rm report_1.tex
    rm -r figure
    cd ../..

    # Generated pdf will be reports/report_1.pdf
    ```

## License
