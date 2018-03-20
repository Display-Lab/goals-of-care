library(stringr)
library(dplyr)

# Read input data if it exists, filter, write to build directory
read_in_data <- function(path, classes){
  df <- read.csv( path, header = TRUE, colClasses = classes )
  df 
}

# Given fy, quart, and number of quarts to go back, return df of fy quart to include
# Parameters:
#  fy: fiscal year of most recent timepoint
#  quart: quarter of most recent timepoint
#  num: number of quarters to go back
# Return:
#   dataframe with num length list of fy & quart starting with timepoint stepping back one quarter at a time
# Description:
#   Put everything in terms of sum of quarters 
#   mapping q1 to 0 and q4 to 3 because 2000q4 != 2005
#   e.g 2000Q1 => 8000, 2001Q4 => 8007 
back_timepoints <- function(fy, quart, num){
  qsum <- fy * 4 + (quart -1)
  # Go back num quarters
  qsum_min <- qsum - (num - 1)
  # Make vector of qsum values 
  qsum_vec <- seq(from=qsum_min, to=qsum)
  
  # Make vector of fy for each qsum value
  fy_vec <- floor(qsum_vec/4)
  # Make vector of quarter for each qsum value
  quart_vec <- qsum_vec %% 4 + 1
  
  data.frame(fy=fy_vec,quart=quart_vec)
}


# Given a clc or hbpc data frame, return one with only the most recent x timepoints
# Fill in rows for missing times
filter_recent_times <- function(df, x){
  # Find most recent time point
  max_fy <- max(df$fy)
  max_fy_filter <- df$fy == max_fy
  max_quart <- max( df[max_fy_filter, c('quart')] )
  
  # get list of timepoints to include
  times <- back_timepoints(max_fy, max_quart, x)
  
  # filter using included times
  time_filter <- paste0(df$fy, df$quart) %in% paste0(times$fy, times$quart)
  df_flt <- df[time_filter,]
  
  # Make list of all site & time point combinations that should be present
  options(stringsAsFactors = FALSE)
  site_times <- merge(unique(df$sta6a),times) %>% rename(sta6a=x)
  
  # Fill missing rows with NA for each ID by joining to the site_times table
  df_flt <- df_flt %>% full_join(site_times)
  
  # Replace NAs with 0 for integer columns
  int_cols <- sapply(df_flt, is.integer)
  na_cells <- is.na(df_flt[, int_cols])
  df_flt[,int_cols][na_cells] <- 0
  
  # return filtered dataframe
  df_flt
}

# Filter the input data to get only the rows that will be used susequently
filter_clc_data <- function(df){
  # Covert column names to lower case
  names(df) <- str_to_lower(names(df))
  
  # Filter for "All Specialties" summary rows
  filter <- df[,"trtsp_1"] == "All NH Treating Specialties"
  flt_data <- df[filter,]
  
  # Filter out all but most recent 8 times
  flt_data <- filter_recent_times(flt_data, 8)
  
  
  # Return filtered data
  flt_data
}

# CLC input is input/clc.csv
clc_filename <- file.path("input","clc.csv")
clc_classes <- c("integer", "integer", rep("character", 2), rep("integer", 7))

# HBPC input is input/hbpc.csv
hbpc_filename <- file.path("input","hbpc.csv")
hbpc_classes <- c("integer","integer","character",rep("integer",7))

# Save filtered data to build directory for later use or examination
if(file.exists(clc_filename)){
  clc_data <- read_in_data(clc_filename, clc_classes)
  flt_data <- filter_clc_data(clc_data)
  
  output_path = file.path("build","filtered_clc.rdata")
  save(flt_data, file = output_path)
}

if(file.exists(hbpc_filename)){
  hbpc_data <- read_in_data(hbpc_filename, hbpc_classes)
  
  # Rename id column for consistency with clc then filter
  flt_data <- hbpc_data %>%
    rename(sta6a=cdw_sta6a) %>%
    filter_recent_times(., 8)
  
  output_path = file.path("build","filtered_hbpc.rdata")
  save(flt_data, file = output_path)
}
