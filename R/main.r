#' @title Main
#' @description Build all reports for input data in input directory
#' @note This is the entry point for the application.
#' @param ... paths to input files for clc, hbpc, or dementia reports
#' @param config_path path to configuration file
#' @param output_dir path to output directory. Defaults to input_dir
#' @param experimental boolean True generates additional experimental reports. Defaults to false
#' @return boolean TRUE indicates successful run.
#' @export
#' 
main <- function(config_path, output_dir = NULL, experimental=FALSE, ...){
  input_args <- list(...)
  
  # Ignore warnings
  options(warn = -1) 
  
  # Default to using working directory output
  if(is.null(output_dir)){ output_dir <- getwd() }
  
  config <- read_config(config_path)
  
  # Read in data
  cat("\n\n--- Reading Data\n")
  clc_inpath <- input_args[['clc']] 
  if(!is.null(clc_inpath) && clc_inpath != ''){
    df_clc  <- read_clc_data(clc_inpath) 
  }
  
  hbpc_inpath <- input_args[['hbpc']]
  if(!is.null(hbpc_inpath) && hbpc_inpath != ''){
    df_hbpc <- read_hbpc_data(hbpc_inpath) 
  }
  
  dementia_inpath <- input_args[['dementia']] 
  if(!is.null(dementia_inpath) && dementia_inpath != ''){
    df_dementia  <- read_dementia_data(dementia_inpath) 
  }
  
  cat("\n\n--- Processing Data\n")
  # Process data
  if(exists('df_hbpc')){
    hbpc_df_list <- process_data(df_hbpc, envir=GOCC$HBPC)
    report_all(hbpc_df_list, GOCC$HBPC, config, output_dir)
    if(experimental){
      # Use shallow-ish duplicate of environment
      exp_env <- as.environment(as.list(GOCC$HBPC, all.names=T))
      attr(exp_env, "name") <- 'hbpcExp'
      exp_env$OUTFILE_PREFIX <-'ex-hbpc' 
      report_all(hbpc_df_list, exp_env, config, output_dir)
    }
  }else{
    cat("\nSkipping HBPC processing")
  }
  
  if(exists('df_clc')){
    clc_df_list <- process_data(df_clc, envir=GOCC$CLC)
    report_all(clc_df_list,  GOCC$CLC,  config, output_dir)
    if(experimental){
      # Use shallow-ish duplicate of environment
      exp_env <- as.environment(as.list(GOCC$CLC, all.names=T))
      attr(exp_env, "name") <- 'clcExp'
      exp_env$OUTFILE_PREFIX <-'ex-clc' 
      report_all(clc_df_list, exp_env, config, output_dir)
    }
  }else{
    cat("\nSkipping CLC processing")
  }
  
  if(exists('df_dementia')){
    dementia_df_list <- process_data(df_dementia, envir=GOCC$DEMENTIA)
    report_all(dementia_df_list,  GOCC$DEMENTIA,  config, output_dir)
  }else{
    cat("\nSkipping Dementia processing")
  }
  
  cat("\n\nEnd of Line\n\n")
}