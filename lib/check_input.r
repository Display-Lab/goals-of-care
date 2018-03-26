library(stringr)
# Pre-process: check validity of input files.
# Function to check that expected columns exist
# Return boolean
check_input <- function(input_path, expected_colnames, expected_classes){
  summ <- read.csv( input_path, header = TRUE, colClasses = expected_classes )
  
  # Check that the header is as expected 
  vars_count <- length(expected_colnames)
 
  cat("Checking number of variables from: ", input_path, "\n")
  cat("Expected:", vars_count, "encountered:", length(summ),"\n")
  
  if(length(summ) != vars_count){
    cat("Unexpected number of variables!\n")
    return(FALSE)
  }
  
  # Check that names of columns matches expected column names converted to lower case
  lower_colnames <- str_to_lower(colnames(summ))
  col_differences <- setdiff(expected_colnames, lower_colnames)
  
  # Report column name differences to std out
  if(length(col_differences) == 0){
    cat("Found expected columns.\n")
  } else {
    cat("Unexpected columns!\n")
    print(col_differences)
    return(FALSE)
  }
  
  # return True if the input appears okay.
  return(TRUE)
}

# Check the CLC input if the input file exists
expected_clc_colnames <- c("fy", "quart", "sta6a", "trtsp_1",
                             "x_freq_", "goc_7", "goc_14", "goc_30", "goc_pre90", 
                             "goc_pre", "goc_none")

expected_clc_classes <- c("integer", "integer", "character", "character", 
                            "integer", "integer", "integer", "integer", "integer",
                            "integer", "integer")

clc_filename <- file.path(here::here(),"input","clc.csv")
print(clc_filename)

if(file.exists(clc_filename)){
  clc_result <- check_input(clc_filename, expected_clc_colnames, expected_clc_classes)
}

# Need to use make names as provided column names (_TYPE_ and _FREQ_) aren't syntacticly valid
expected_hbc_colnames <- make.names(c("fy","quart","cdw_sta6a","hbpc","numer1","numer2","numer3","denom90","numer90","goc_pre"))

expected_hbc_classes <- c("integer","integer","character",rep("integer",7))

hbc_filename <- file.path(here::here(),"input","hbpc.csv")
print(hbc_filename)

if(file.exists(hbc_filename)){
  hbc_result <- check_input(hbc_filename, expected_hbc_colnames, expected_hbc_classes)
}


# Exit with status code 65 in the event hbpc or clc input files aren't good
if(exists('clc_result')){
  if(clc_result == FALSE){
    quit(save='no', status=65)
  }
}
if(exists('hbc_result')){
  if(hbc_result == FALSE){
    quit(save='no', status=65)
  }
}

# Handle case where neither input exist
if(!exists('clc_result') && !exists('hbc_result')){
  cat("\n\n!!! NO INPUT FILES FOUND !!!")
  cat("\n\n!!! Expected input/clc.csv or input/hbpc.csv !!!")
  quit(save='no', status=65)
}
