#!/usr/bin/env bash

# Discover project root directory regardless of symlinks
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
	echo $DIR
}

# Assume project root is one directory up, and 
#  change to the project root directory.
SCRIPT_DIR=$(get_script_dir)
PROJ_DIR=$(dirname ${SCRIPT_DIR})

echo "Project Directory: $(PROJ_DIR)"

DATE=$(date +%Y-%m-%d_%H%M%S)
BACKUP_CFG="${PROJ_DIR}/config/report_settings.${DATE}.yml"
BACKUP_CLC_DATA="${PROJ_DIR}/input/clc.${DATE}.csv"
BACKUP_HBPC_DATA="${PROJ_DIR}/input/hpbc.${DATE}.csv"

# Backup report_settings.yml if present
if [ -f "$(PROJ_DIR)/config/report_settings.yml" ]
then
  echo "~~~"
  echo "Backing up report settings to ${BACKUP_CFG}"
  cp $(PROJ_DIR)/config/report_settings.yml ${BACKUP_CFG}
fi

if [ ! -f "$(PROJ_DIR)/config/report_settings.yml.sample" ]
then
  echo "!!!"
  echo "Sample report settings missing!"
  echo "!!!"
  exit 1
else
  echo "~~~"
  echo "Copying sample settings to config/report_settings.yml"
  cp $(PROJ_DIR)/config/report_settings.yml.sample $(PROJ_DIR)/config/report_settings.yml
fi

# Backup clc and hbpc data if present
if [ -f $(PROJ_DIR)/input/clc.csv ]
then
  echo "~~~"
  echo "Backing up clc.csv to ${BACKUP_CLC_DATA}"
  cp $(PROJ_DIR)/input/clc.csv ${BACKUP_CLC_DATA}
fi

if [ -f $(PROJ_DIR)/input/hbpc.csv ]
then
  echo "~~~"
  echo "Backing up hbpc.csv to ${BACKUP_HBPC_DATA}"
  cp $(PROJ_DIR)/input/hbpc.csv ${BACKUP_HBPC_DATA}
fi

# Generate sample data
  echo "~~~"
  echo "Generating synthetic clc.clv and hbpc.clc in input/"

Rscript "${PROJ_DIR}/lib/synth_clc_data.r"  
Rscript "${PROJ_DIR}/lib/synth_hbpc_data.r"  

# Print Running instructions
  echo "~~~"
  echo "Run build script:"
  echo "bin/build_reports.sh"
  echo ""
