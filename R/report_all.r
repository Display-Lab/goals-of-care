#' @title Report All
#' @description Run report for all IDs in the data.
#' @param df_list list of data frames.  One for rate and one for category
#' @param envir environment corresponding to the report template and data provided.
#' @param config external configuration
#' @param output_dir destination for reports
report_all <- function(df_list, envir, config, output_dir){
  ids <- unique(df_list$rate[,"id"])
  
  cat(paste("\n\n----Generating", environmentName(envir), "Reports\n"))
  successes <- sapply(ids, FUN=report_one, df_list, envir, config, output_dir)
  
  num_reports <- sum(successes)
  cat(paste("\nCreated ", num_reports, environmentName(envir),"reports.\n"))
  
  return(num_reports)
}

#' @title Report One
#' @description Create report for a single id
#' @param id by which to subset
#' @param envir with name matching the convention for the corresponding template
#' @param config external configuration information
#' @param output_directory path to directory where output file will be deposited.
#' @import tinytex
#' @importFrom knitr knit2pdf
#' @importFrom utils capture.output
#' @importFrom tools file_path_sans_ext
report_one <- function(id, df_list, envir, config, output_dir){
  # Only generate reports that there is a config for.
  memo_type <- environmentName(envir)
  report_env <- build_report_env(config, memo_type, id)
  if(is.null(report_env)){ 
    cat("x")
    return(FALSE) 
  } else {
    cat(".")
  }
  
  # Add data into environment
  report_env$rate_data     <- df_list$rate
  report_env$category_data <- df_list$category
  
  template_file <- paste(memo_type, ".Rnw", sep="")
  template_path <- system.file(file.path("templates", template_file), package="gocc")
  
  out_filename <- paste(envir$OUTFILE_PREFIX, report_env$name, "pdf", sep=".")
  build_dir <- tempdir()
  
  output_path = file.path(output_dir, out_filename)
  
  options(tinytex.engine="pdflatex")
  suppressMessages(
    utils::capture.output(
      knitr::knit2pdf(input = template_path,
                    envir=report_env,
                    pdf_file= output_path)
  ) )
  
  return(TRUE)
}

#' @title Build Report Environment
#' @description Create report environment from config
#' @param config external configuration information
#' @param memo_type with name matching the convention for the corresponding template
#' @param id by which to subset
build_report_env <- function(config, memo_type, id){
  site_cfg <- config[[ c(memo_type, "sites", id) ]]
  type_cfg <- config[[ memo_type ]]
  
  if(is.null(site_cfg)){ return(NULL) }
  
  # Assign values
  report_env <- new.env()
  report_env$selected_id   <- id
  report_env$title         <- type_cfg$title
  report_env$assists       <- type_cfg$assists
  report_env$name          <- site_cfg$name
  report_env$provider      <- site_cfg$provider
  report_env$contacts      <- site_cfg$contacts
  report_env$tips          <- site_cfg$tips
  report_env$docompare     <- site_cfg$docompare
  
  return(report_env)
}