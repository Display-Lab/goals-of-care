# VA GoCC Command Line Demo

cd workspace/gocc

bin/gocc.sh --help

# Configuration is a yaml file

less config/report_settings.yml

# Inputs are csv files.  One per project.

head input/clc.csv

head input/hbpc.csv

head input/dementia.csv #(project 2)

# Reports generated based on input data arguments.
#  E.g. use --clc input/clc.csv to generate CLC reports.

bin/gocc.sh -c config/report_settings.yml --clc input/clc.csv

# The program stdout indicates reports generated and skipped with . and x
# Resulting reports are in the "build" directory

ls build

