# Goals of Care Site Reports

## Prerequisites

### LaTeX
For Windows users MikTex is suggested [https://miktex.org/](https://miktex.org/)

### Pandoc
Home Page [https://www.pandoc.org](https://www.pandoc.org)

Pandoc is a requirement of the knitr package.  For command line Rscript, `pandoc` needs to be included in `PATH`.

### R
Home Page [https://cran.r-project.org/](https://cran.r-project.org/)

Optionally, use RStudio to get a GUI. [https://www.rstudio.com/](https://www.rstudio.com/)

### R Packages
* ggplot2
* ggthemes
* viridis
* scales
* tidyr
* config
* dplyr
* knitr

Included under lib/ is an installer script that will attempt to download, build, and install required packages: [lib/required-packages.r](lib/required-packages.r)

## Use

1. Gather input data and export in csv format with a header row into the input/ directory.
    * Expected input file input/clc.csv
    * Expected input file input/hbpc.csv

1. Fill out the configuration file `config/report_settings.yml`
    * An example config with defaults settings exits at `config/report_settings.yml.sample`
      ```
      cp config/report_settings.yml.sample config/report_settings.yml
      ```

1. From the project root directory, run the following commands in order:
    ```
    # Run install script to make sure required packages are installed.
    Rscript lib/install_required_packages.r

    # Check that input data has expected headers
    Rscript lib/check_input.r

    # Filter the input data
    Rscript lib/filter_input.r

    # Calculate performance measure
    Rscript lib/calc_perf_measures.r

    # Build all report figures and tex
    Rscript lib/build_all_tex.r

    # Compile all tex reports to pdf
    find build -name '*.tex' -execdir pdflatex {} \;

    # Generated pdf will be build/reports/<id>/<id>_clc.pdf
    ```

## Configuration
Various strings that appear in the reports need to be changed per recipient.
To facilitate this, those strings are specified in `config/report_settings.yml`.

Important Config Notes
* **The config file must exist**
* The config must be filled out for each id that exists in the input data.
* The config must start with the key `default`
* The config should contain a config for `clc` & `hbpc`.
* The config file is not being tracked in version control.

```yaml
---
default:
  clc:
    title: Title of the Report
    assists:
      - Data collected quarterly.
      - Data is analyzed in aggregate.
      - Your millage may vary.
    sites:
      nTR:
        name: No Trend Location
        contacts:
          - Jane Smith, Product Owner (555-555-5555)
          - John Jones, No Trend Manager (555-222-9101)
        provider: Reporting Committe for Reporting Reports
      9984: 
        name: Randal Trenderson Building
        contacts: John Jones, Random Manager (555-222-1121)
        provider: Friendly Neighborhood Feedback Provider
```

## License
