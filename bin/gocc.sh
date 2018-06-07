#!/usr/bin/env bash

# Check if R is installed
command -v Rscript 1> /dev/null 2>&1 || \
  { echo >&2 "Rscript required but it's not installed.  Aborting."; exit 1; }

# Usage message
read -r -d '' USE_MSG <<'HEREDOC'
Usage:
  gocc.sh -h
  gocc.sh input_dir config_file
  gocc.sh -i [path to input dir] -c [path to config]
  gocc.sh --input [path to input dir] --config [path to config]

Input directory is expected to contain hbpc.csv and clc.csv files.

Options:
  -h | --help   print help and exit
  -i | --input  path to input directory
  -c | --config path to configuration file
  -o | --output path to output directory
HEREDOC

# Parse args
PARAMS=()
while (( "$#" )); do
  case "$1" in
    -h|--help)
      echo "${USE_MSG}"
      exit 0
      ;;
    -i|--input)
      INPUT_DIR=$2
      shift 2
      ;;
    -c|--config)
      CONFIG_FILE=$2
      shift 2
      ;;
    -o|--output)
      OUTPUT_DIR=$2
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Aborting: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS+=("${1}")
      shift
      ;;
  esac
done

# Sort out input directory and shift params if used
if [[ -z $INPUT_DIR ]]; then
  if [[ ${PARAMS[0]} ]]; then
    INPUT_DIR="${PARAMS[0]}"
    PARAMS=("${PARAMS[@]:1}")
  else
    echo "Aborting: Input directory required."
    exit 1
  fi
fi

# Sort out config file. 
# Check 2nd param (unshifted case) then 1st param (shifted case)
if [[ -z $CONFIG_FILE ]]; then
  if [[ ${PARAMS[1]} ]]; then
    CONFIG_FILE="${PARAMS[1]}"
  elif [[ ${PARAMS[0]} ]]; then
    CONFIG_FILE="${PARAMS[0]}"
  else
    echo "Aborting: Config file required."
    exit 1
  fi
fi

if [[ -z $OUTPUT_DIR ]]; then
    OUTPUT_DIR="${PWD}/build"
fi

echo "Creating ${OUTPUT_DIR} if it doesn't exist"
mkdir -p "${OUTPUT_DIR}"

echo "Running GoCC R Package."
EXPR="gocc::main('${INPUT_DIR}', '${CONFIG_FILE}', '${OUTPUT_DIR}')"
echo "${EXPR}"
Rscript --vanilla --default-packages=gocc -e "${EXPR}"

echo "Cleaning up: framed.sty, report.tex, figures/"
rm -f "framed.sty"
rm -f "report.tex"
rm -rf "figures"
