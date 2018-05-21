# Goals of Care Site Reports

## Installation
This project makes use of `Rscript`,`pandoc`, and `pdflatex`.
All should be in the PATH of the executing user. 
Ensure the R Packages listed in the prerequisites section are installed and available. 

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
- ggplot2
- ggthemes
- viridis
- scales
- tidyverse
- config
- stringr
- dplyr
- knitr
- rmarkdown
- here

Included under lib/ is an installer script that will attempt to download, build, and install required packages: [lib/required-packages.r](lib/required-packages.r)

## Use
1. Change directory to the project root directory.

1. Gather input data and export in csv format with a header row into the input/ directory.
    - Expected input file input/clc.csv
    - Expected input file input/hbpc.csv

1. Fill out the configuration file `config/report_settings.yml`
    - An example config with defaults settings exists at `config/report_settings.yml.sample`
      ```console
      cp config/report_settings.yml.sample config/report_settings.yml
      ```

1. Run the bash script to execute all commands, **OR** manually run each individually:
    - **BASH Script** From project base directory, run the following:
        ```console
        # Run the commands to build the reports
        bin/build_reports.sh

        # Check the log for errors
        grep -e 'Error' build/build.log
        ```

    - **Manual** From the project base directory, run the following commands in order:
        ```console
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

        # Generated pdf will be build/reports/<id>_clc/<id>.clc.pdf
        # Generated pdf will be build/reports/<id>_hbpc/<id>.hbpc.pdf
        ```
1. Collect the generated reports from the directory `build/reports/`

## Demo with synthetic data
### Config & Input Data Backups
The generate example data script makes a backup of any existing data in the input directory.
It will also make a backup of the report_settings.yml in a similar fashion.
So multiple runs of the demo will result in backups of the synthetic data and config.
### Running the Demo
Run the following commands from the project base directory. 
```console
# Generate fake data
bin/generate_example_data.sh

# Build reports using fake data
bin/build_reports.sh
```

## Configuration
Various strings that appear in the reports need to be changed per recipient.
To facilitate this, those strings are specified in a yaml configuration file `config/report_settings.yml`.
YAML overview: [https://en.wikipedia.org/wiki/YAML](https://en.wikipedia.org/wiki/YAML)
YAML technical specification: [yaml.org](yaml.org)

Important Config Notes
- **The config file must exist**
- The config must be filled out for each id that exists in the input data.
- The config must start with the key `default`
- The config should contain a config for `clc` & `hbpc`.

Example:

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
Copyright 2018 Regents of the University of Michigan

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
