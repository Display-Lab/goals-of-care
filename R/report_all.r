#' @title Report All
#' @description Run report for all IDs in the data.
#' @param df_list list of data frames.  One for rate and one for category
#' @param envir environment corresponding to the report template and data provided.
#' @param config external configuration
#' @param output_dir destination for reports
report_all <- function(df_list, envir, config, output_dir){
  
  ids <- unique(df_list$rate[,"id"])
  
  # Build report
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
#' @importFrom knitr knit2pdf
#' @importFrom utils capture.output
report_one <- function(id, df_list, envir, config, output_dir){
  cat(".")
  memo_type <- environmentName(envir)
  type_cfg <- config[[ memo_type ]]
  site_cfg <- config[[ c(memo_type, "sites", id) ]]
  
  report_env <- new.env()
  report_env$selected_id   <- id
  report_env$rate_data     <- df_list$rate
  report_env$category_data <- df_list$category
  report_env$title         <- type_cfg$title
  report_env$assists       <- type_cfg$assists
  report_env$name          <- site_cfg$name
  report_env$provider      <- site_cfg$provider
  report_env$contacts      <- site_cfg$contacts
  report_env$rate_data     <- df_list$rate
  report_env$category_data <- df_list$category
  
  template_path <- system.file(file.path("templates", memo_type,"report.Rnw"), package="gocc")
  tex_inputs_path <- system.file(file.path("templates", memo_type), package="gocc") 
  
  out_filename <- paste(envir$OUTFILE_PREFIX, id, "pdf", sep=".")
  build_dir <- tempdir()
  
  output_path = file.path(output_dir, out_filename)
  
  suppressMessages(
    utils::capture.output(
      knitr::knit2pdf(input = template_path,
                    envir=report_env,
                    pdf_file= output_path)
    )
  )
  
  return(TRUE)
}
