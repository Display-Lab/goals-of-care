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
cd ${PROJ_DIR}

LOGFILE="${PROJ_DIR}/build/build.log"
DATE=$(date +%Y-%m-%d:%H:%M:%S)


echo "Started build log at ${PROJ_DIR}/build/build.log"

# Clear out any existing intermediate data
echo "Starting Build: ${DATE}" > "${LOGFILE}" 
echo "Removing any intermediate data" >> "${LOGFILE}" 
find "${PROJ_DIR}" -type f -name '*.rdata' -exec rm {} +

echo "Checking if required R packages are installed" | tee -a "${LOGFILE}" 
Rscript "${PROJ_DIR}/lib/install_required_packages.r" 1>>"${LOGFILE}" 2>&1 
if [ $? -ne 0 ]
then
  echo "Problem installing R packages."
  echo "Verify required packages are installed and accessible."
  exit 1
fi

echo "Checking that input data has expected headers" | tee -a "${LOGFILE}"
Rscript "${PROJ_DIR}/lib/check_input.r" 1>>"${LOGFILE}" 2>&1 
if [ $? -ne 0 ]
then
  echo "Problem encountered verifying input data."
  echo "Check that expected header and columns are present."
  exit 1
fi

echo "Filtering the input data" | tee -a "${LOGFILE}"
Rscript "${PROJ_DIR}/lib/filter_input.r" 1>>"${LOGFILE}" 2>&1 
if [ $? -ne 0 ]
then
  echo "Problem filtering input data."
  echo "Check build log for more information."
  exit 1
fi

echo "Calculating performance measures" | tee -a "${LOGFILE}"
Rscript "${PROJ_DIR}/lib/calc_perf_measures.r" 1>>"${LOGFILE}" 2>&1 

echo "Building report figures and tex" | tee -a "${LOGFILE}"
Rscript "${PROJ_DIR}/lib/build_all_tex.r" 1>>"${LOGFILE}" 2>&1 

echo "Finding tex reports and compiling to pdf" | tee -a "${LOGFILE}"
find ${PROJ_DIR}/build -name '*.tex' -execdir pdflatex {} \; 1>>"${LOGFILE}" 2>&1 

echo "Done" 1>> "${LOGFILE}"
echo "Generated reports in ${PROJ_DIR}/build/reports"
