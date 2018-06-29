[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1300783.svg)](https://doi.org/10.5281/zenodo.1300783)
# Goals of Care Site Reports

## Installation
Installation instructions are inteneted to be run from the directory that contains the `gocc` directory.
For example, if `/home/joe/projects/gocc` is where the gocc source directory will reside, then the commands below should be run from `/home/joe/projects`.

1. Install Prequisites (details below)
1. Clone repository into directory named `gocc`
    ```console
    git clone https://github.com/Display-Lab/goals-of-care gocc
    ```
1. Install gocc package dependencies
    ```console
    Rscript --vanilla -e 'install.packages("devtools", repos="http://cran.us.r-project.org")'
    Rscript --vanilla -e 'devtools::install_deps(pkg="gocc", dependencies=TRUE)'
    ```
1. Install gocc package from source directory
    ```console
    R CMD INSTALL --preclean --no-multiarch --with-keep.source gocc
    ```
### Update
1. Navigate to gocc source directory
    ```console
    cd /path/to/gocc
    ```
1. Pull latest source code
    ```console
    git pull
    ```
1. Navidate on directory up and follow final two steps from installation instructions above.
    ```console
    cd ..
    Rscript --vanilla -e 'install.packages("devtools", repos="http://cran.us.r-project.org")'
    Rscript --vanilla -e 'devtools::install_deps(pkg="gocc", dependencies=TRUE)'
    R CMD INSTALL --preclean --no-multiarch --with-keep.source gocc
    ```


## Package Use
The package comes with a command line utility script in `bin/gocc.sh`
1. Gather input data and export in csv format with a header row into the input/ directory.
    - Expected input file input/clc.csv
    - Expected input file input/hbpc.csv

1. Make a configuration file `config/report_settings.yml`
    - An example config with defaults settings exists in the package source directory under `config/report_settings.yml.sample`

1. Run the report generation script supplying the path to your inputs directory and config file.
    ```console
      /path/to/gocc/bin/gocc.sh input config/report_settings.yml
    ```

### Example Directory
The expected use and example directory structure that was used for testing is shown in the tree.
gocc.sh is a symlink to the shell script in the package
```
gocctest/
├── config
│   └── report_settings.yml
├── gocc.sh -> /home/grosscol/workspace/gocc/bin/gocc.sh
└── input
    ├── clc.csv
    └── hbpc.csv
```
From within `gocctest`, the command used to run the example is
```console
./gocc.sh input config/report_settings.yml
```

## Prerequisites
This project makes use of `R`, `Rscript`,`pandoc`, and `pdflatex`.
All should be in the PATH of the user. 
Ensure the R Packages listed in this section are installed and available for the user. 

### LaTeX
For Windows users MikTex is suggested [https://miktex.org/](https://miktex.org/)

### Pandoc
Home Page [https://www.pandoc.org](https://www.pandoc.org)

Pandoc is a requirement of the knitr package.  For command line Rscript, `pandoc` needs to be included in `PATH`.

### R
Home Page [https://cran.r-project.org/](https://cran.r-project.org/)

Optionally, use RStudio to get a GUI. [https://www.rstudio.com/](https://www.rstudio.com/)

### R Packages
- config,
- dplyr,
- ggplot2,
- ggthemes,
- knitr,
- magrittr,
- rmarkdown,
- scales,
- stringr,
- tidyr,
- tools,
- utils,
- viridis

Included under lib/ is an installer script that will attempt to download, build, and install required packages: [lib/required-packages.r](lib/required-packages.r)

## Configuration
Various strings that appear in the reports need to be changed per recipient.
To facilitate this, those strings are specified in a yaml configuration file `config/report_settings.yml`.
- YAML overview: [https://en.wikipedia.org/wiki/YAML](https://en.wikipedia.org/wiki/YAML)
- YAML technical specification: [yaml.org](yaml.org)

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
