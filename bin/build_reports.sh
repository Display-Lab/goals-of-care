#!/usr/bin/env bash

# Run R scripts to build HBPC and CLC reports if data is available.

# Check that this is being run from the project root directory,
get_script_dir(){
	SOURCE="${BASH_SOURCE[0]}"
	# While $SOURCE is a symlink, resolve it
	while [ -h "$SOURCE" ]; do
		DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
		SOURCE="$( readlink "$SOURCE" )"
		# If $SOURCE was a relative symlink, 
    #  resolve it relative to the symlink base directory
		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
	done
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	echo "$DIR"
}

# Assume project root is one directory up, and 
#  change to the project root directory.
SCRIPT_DIR=$(get_script_dir)
PROJ_DIR=$(dirname ${SCRIPT_DIR})

LOGFILE="${PROJ_DIR}/build/build.log"

# Clear out any existing intermediate data
rm "${PROJ_DIR}/build/*.rdata"

# Run install script to make sure required packages are installed.
Rscript "${PROJ_DIR}/lib/install_required_packages.r"

# Check that input data has expected headers
Rscript "${PROJ_DIR}/lib/check_input.r"

# Filter the input data
Rscript "${PROJ_DIR}/lib/filter_input.r"

# Calculate performance measure
Rscript "${PROJ_DIR}/lib/calc_perf_measures.r"

# Build all report figures and tex
Rscript "${PROJ_DIR}/lib/build_all_tex.r"

# Compile all tex reports to pdf
find ${PROJ_DIR}/build -name '*.tex' -execdir pdflatex {} \;

echo "Generated pdf will be ${PROJ_DIR}/build/reports"

