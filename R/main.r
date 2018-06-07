#' @title Main
#' @description Build all reports for input data in input directory
#' @note This is the entry point for the application.
#' @param input_dir path to directory that contains clc.csv or hbpc.csv
#' @param config_path path to configuration file
#' @param output_dir path to output directory. Defaults to input_dir
#' @return boolean TRUE indicates successful run.
#' @export
#' 
main <- function(input_dir, config_path, output_dir = NULL){
  # Ignore warnings
  options(warn = -1) 
  
  # Default to using same directory for input and output
  if(is.null(output_dir)){ output_dir <- input_dir }
  
  config <- read_config(config_path)
  
  # Read in CLC and HBPC data frames
  cat("\n\n--- ReadingData\n")
  clc_filename <- file.path(input_dir,"clc.csv")
  hbpc_filename <- file.path(input_dir,"hbpc.csv")
  
  df_hbpc <- read_hbpc_data(hbpc_filename) 
  df_clc  <- read_clc_data(clc_filename) 
  
  # Process Data
  if(!is.null(df_hbpc)){
    hbpc_df_list <- process_data(df_hbpc, envir=GOCC$HBPC)
  }else{
    cat(paste("\nHBPC input file", hbpc_filename, "not present or malformed.\n"))
    hbpc_df_list <- list()
  }
  
  if(!is.null(df_clc)){
    clc_df_list <- process_data(df_clc, envir=GOCC$CLC)
  }else{
    cat(paste("\nCLC input file", clc_filename, "not present or malformed.\n"))
    clc_df_list <- list()
  }
  
  report_all(hbpc_df_list, GOCC$HBPC, config, output_dir)
  report_all(clc_df_list,  GOCC$CLC,  config, output_dir)
  
  cat("\n\nEnd of Line\n\n")
}