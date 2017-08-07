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
cd "${SCRIPT_DIR}/.."

# Clear out any existing intermediate data
rm build/*.rdata

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

echo "Generated pdf will be build/reports"

