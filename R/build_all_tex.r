#' @title Build All Tex
#' @description Build all the LaTeX report outputs for all ids in the input data
#' @param rate_df dataframe of rate data to be plotted
#' @param category_df dataframe of category data to be plotted
#' @param memo_type "hbpc" | "clc" informing which tempalte to use.
#' @importFrom rmarkdown render
build_all_tex <- function(rate_df, category_df, memo_type, output_dir){
  ids <- levels(rate_df$id)
  
  # create build & report directories if they don't exist
  reports_dir <- file.path(output_dir, "reports") # output directory for render
  build_dir   <- file.path(output_dir, "build")   # intermediates dir for render
  dir.create(build_dir,   recursive = T, showWarnings = F)
  dir.create(reports_dir, recursive = T, showWarnings = F)
  
  # Path to package internal report template
  template_path <- system.file(file.path("templates", memo_type,"report.Rnw"), package="gocc")
  
  # run report generation for each id
  successes <- sapply(ids, FUN=generate_report,
                      rate_df       = rate_df,
                      category_df   = category_df,
                      template_path = template_path, 
                      build_dir     = build_dir, 
                      reports_dir   = reports_dir)
  
  return(sum(successes))
}

#' @title Generate Report
#' @description Generate the report for an individual id.
generate_report <- function(id, rate_df, category_df, template_path, build_dir, reports_dir){
  
  report_env <- new.env()
  report_env$selected_id <- id
  report_env$rate_data
  report_env$category_data
  
  rmarkdown::render(input = template_path,
                    output_dir = reports_dir,
                    output_file = 'outfilename',
                    intermediates_dir = build_dir,
                    envir = report_env)
  return(TRUE)
}


