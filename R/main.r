#' @title Main
#' @description Build all reports for input data in input directory
#' @note This is the entry point for the application.
#' @param input_directory path to directory that contains clc.csv or hbpc.csv
#' @param config_path path to configuration file
#' @return boolean TRUE indicates successful run.
#' @export
#' 
main <- function(input_directory, config_path){
  # Read in CLC and HBPC data frames
  clc_filename <- file.path(input_directory,"clc.csv")
  hbpc_filename <- file.path(input_directory,"hbpc.csv")
  
  df_hbpc <- read_hbpc_data() 
  df_clc  <- read_clc_data() 
  
  if(!is.null(df_hbpc)){
    process_data(df_hbpc, envir)
  }else{
    cat(paste("\nHBPC input file", hbpc_filename, "not present or malformed.\n"))
  }
  
  # Filter input
  
  # Calc Measures
  
  # Build reports
  
}

process_data <- function(df, envir){
  # Check for valid inputs
  valid_input <- check_input(df, envir$COL_NAMES)
  if(!valid_input){
    cat("Aborting: Problem with input data.\n")
    return(FALSE)
  }
  
  return(TRUE)
}

