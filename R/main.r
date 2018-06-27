#' @title Main
#' @description Build all reports for input data in input directory
#' @note This is the entry point for the application.
#' @param ... paths to input files for clc, hbpc, or dementia reports
#' @param config_path path to configuration file
#' @param output_dir path to output directory. Defaults to input_dir
#' @return boolean TRUE indicates successful run.
#' @export
#' 
main <- function(config_path, output_dir = NULL, ...){
  cat("\nDEBUG\n")
  cat(config_path)
  cat("\nDEBUG\n")
  cat(output_dir)
  cat("\n")
  
  input_args <- list(...)
  
  # Ignore warnings
  options(warn = -1) 
  
  # Default to using working directory output
  if(is.null(output_dir)){ output_dir <- getwd() }
  
  config <- read_config(config_path)
  
  # Read in data
  cat("\n\n--- ReadingData\n")
  clc_inpath <- input_args[['clc']] 
  if(!is.null(clc_inpath) || clc_inpath != ''){
    df_clc  <- read_clc_data(input_args[['clc']]) 
  }
  
  hbpc_inpath <- input_args[['hbpc']]
  if(!is.null(hbpc_inpath) || hbpc_inpath != ''){
    df_hbpc <- read_hbpc_data(hbpc_inpath) 
  }
  
  # Process data
  if(!is.null(df_hbpc)){
    hbpc_df_list <- process_data(df_hbpc, envir=GOCC$HBPC)
    report_all(hbpc_df_list, GOCC$HBPC, config, output_dir)
  }else{
    cat(paste("\nHBPC input file", hbpc_inpath, "not present or malformed.\n"))
    hbpc_df_list <- list()
  }
  
  if(!is.null(df_clc)){
    clc_df_list <- process_data(df_clc, envir=GOCC$CLC)
    report_all(clc_df_list,  GOCC$CLC,  config, output_dir)
  }else{
    cat(paste("\nCLC input file", clc_inpath, "not present or malformed.\n"))
    clc_df_list <- list()
  }
  
  
  cat("\n\nEnd of Line\n\n")
}