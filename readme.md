# Goals of Care Site Reports

## Prerequisites

### LaTeX
[https://miktex.org/](https://miktex.org/)

### R
Home Page [https://cran.r-project.org/](https://cran.r-project.org/)

Optionally, use RStudio to get a GUI interface and pandoc bundled.

### Pandoc

Home page and project information: [http://pandoc.org/](http://pandoc.org/)

Windows installers available at [https://github.com/jgm/pandoc/releases](https://github.com/jgm/pandoc/releases).

### R Packages
* ggplot2
* ggthemes
* tidyverse
* knitr
* rmarkdown

Included under lib/ is an installer script that will attempt to download, build, and install required packages: [required-packages.r](lib/required-packages.r)

## Use

1. Gather input data and export as an .rdata file in the input/ directory.
    * Default behavior is to use the first .rdata file found in input/
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
    Rscript lib\check-input.r
    ```

  * Windows CMD
    ```
    echo Run install script to make sure required packages are installed.
    Rscript lib\required-packages.r

    REM Check that input data has expected headers
    Rscript lib\check-input.r
    ```

  * Linux/OSX:

    ```
    # Run install script to make sure required packages are installed.
    Rscript lib/required-packages.r

    # Check that input data has expected headers
    Rscript lib/check-inputs.r
    ```

## License
