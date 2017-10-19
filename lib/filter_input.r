library(stringr)
# Read input data if it exists, filter, write to build directory
read_in_data <- function(path, classes){
  df <- read.csv( path, header = TRUE, colClasses = classes )
  df 
}

# Filter the input data to get only the rows that will be used susequently
filter_clc_data <- function(df){
  # Covert column names to lower case
  names(df) <- str_to_lower(names(df))
  
  # Create a array of boolean (TRUE) with one value per row in the data frame
  filter <- rep(TRUE, nrow(df))
  
  # Only use rows with the treatment specialty value of "All Speciialties"
  # Logical AND together the base filter with rows for which the condition is true
  filter <- filter & df[,"trtsp_1"] == "All NH Treating Specialties"
  
  # Only use rows with a time in the top 8 time points (fiscal year quarters in practice)
  # Unique Times, Top time index, top times dataframe
  uniq_t <- unique(df[,c('fy','quart')])
  top_t_idx <- order(uniq_t$fy, uniq_t$quart, decreasing=T)[1:8]
  top_t <- uniq_t[top_t_idx, c('fy','quart')]
  
  # Add time_filter to overall filter
  time_filter <- paste0(df$fy, df$quart) %in% paste0(top_t$fy, top_t$quart)
  filter <- filter & time_filter
  
  # Apply filter to get filtered data
  # Subset the data by selecting rows that correspond to TRUE in the filter.
  flt_data <- df[filter,]
  
}

# CLC input is input/clc.csv
clc_filename <- file.path("input","clc.csv")
clc_classes <- c("integer", "integer", rep("character", 5), rep("integer", 10))

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
  flt_data <- hbpc_data
  
  output_path = file.path("build","filtered_hbpc.rdata")
  save(flt_data, file = output_path)
}
