#' @title Check Input
#' @description Check existance and validity of input files
#' @param input_path path to directory containing input files.
#' @return boolean TRUE indicates at least one input file is present and valid.
check_input <- function(input_dir){
  clc_input_file <- file.path(input_dir, "clc.csv")
  hbpc_input_file <- file.path(input_dir, "hbpc.csv")
  
  clc_result  <- check_input_clc(clc_input_file)
  hbpc_result <- check_input_hbpc(hbpc_input_file)
  
  # Emit messages for logging
  if(!clc_result){
    cat(paste("\nCLC input file", clc_input_file, "not present or malformed.\n"))
  }
  if(!hbpc_result){
    cat(paste("\nHBPC input file", hbpc_input_file, "not present or malformed.\n"))
  }
  
  return( clc_result && hbpc_result )
}

#' @title Check Input CLC
#' @description Convenience wrapper to supply the expected col names and classes
#' @param input_path path to input csv
#' @return boolean.  Answers, is clc input present AND good?
check_input_clc <- function(input_path){
  expected_colnames <- c("fy", "quart", "sta6a", "trtsp_1",
                         "x_freq_", "goc_7", "goc_14", "goc_30", "goc_pre90", 
                         "goc_pre", "goc_none")
  
  expected_classes <- c("integer", "integer", "character", "character", 
                        "integer", "integer", "integer", "integer", "integer",
                        "integer", "integer")
  
  if(file.exists(input_path)){
    result <- check_input_data(input_path, expected_colnames, expected_classes)
  }else{
    result <- FALSE
  }
  return(result)
}

#' @title Check Input HBPC
#' @description Convenience wrapper to supply the expected col names and classes
#' @param input_path path to input csv
#' @return boolean.  Answers, is hpbc input present AND good?
check_input_hbpc <- function(input_path){
  # Need to use make names as provided column names (_TYPE_ and _FREQ_) aren't syntacticly valid
  expected_hbc_colnames <- make.names(c("fy","quart","cdw_sta6a","hbpc","numer1","numer2","numer3","denom90","numer90","goc_pre"))
  
  expected_hbc_classes <- c("integer","integer","character",rep("integer",7))
  
  hbc_filename <- file.path("input","hbpc.csv")
  if(file.exists(hbc_filename)){
    result <- check_input_data(hbc_filename, expected_hbc_colnames, expected_hbc_classes)
  }else{
    result <- FALSE
  }
  return(result)
}

#' @title Check Input Data
#' @description Make a pass through data for conformance to expected col names and classes.
#' @param input_path path to input CSV file
#' @param expected_colnames vector of names that need to match the column headers
#' @param expected_classes vector of column types provided as strings
#' @importFrom stringr str_to_lower
check_input_data <- function(input_path, expected_colnames, expected_classes){
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
