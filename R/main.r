#' @title Main
#' @description Build all reports for input data in input directory
#' @note This is the entry point for the application.
#' @return boolean TRUE indicates successful run.
#' @export
#' 
main <- function(input_directory, config_path){
  inputs_valid <- check_input(input_directory)
  
  if(!inputs_valid){
    cat("\n\n!!! NO VALID INPUT FILES FOUND !!!")
    cat("\n\n!!! Expected clc.csv or hbpc.csv !!!")
    return(FALSE)
  }
  
  # Filter input
  
  # Calc Measures
  
  # Build reports
  
}
