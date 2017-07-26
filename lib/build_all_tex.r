library(knitr)

report_dir_path <- function (id, memo_type){
  name <- file.path("build","reports",paste(id, memo_type, sep="_"))
}

create_report_dir <- function(id, memo_type){
  dir.create(report_dir_path(id, memo_type), showWarnings = FALSE)
}

# Generate a report for a single recipient
# Id selects the memo recipient to subset the data
# Use clc or hbpc as the memo type
generate_report <- function(id, memo_type){
  # Setup the directory and file names.
  memo_dir_name <- paste(memo_type,"memo",sep="_")
  report_filename <- paste(id, memo_type, "tex", sep=".")
  dest_dir <- report_dir_path(id, memo_type)
  
  # Generate a CLC Report passing selected_id via the global env
  # Selected id is a variable used in the report script.
  selected_id <- id
  knitr_file <- file.path("lib",memo_dir_name,"report.Rnw")
  knit(input= knitr_file)
  
  # Clean destination figures directory
  unlink(file.path(dest_dir, "figure"), recursive = TRUE)
  
  # Move the products of the report to the build/reports directory
  file.rename( from="figure",       to=file.path(dest_dir, "figure") )
  file.rename( from="report.tex", to=file.path(dest_dir, report_filename) )
  
  # Copy the memo class file into the report directory
  file.copy(from=file.path("lib",memo_dir_name,"texMemo.cls"), to=file.path(dest_dir,"texMemo.cls"))
  
  # Return true for successfully generating and moving files
  return(TRUE)
}

run_report_for_all_ids <- function(input_path, memo_type){
  load(input_path)
  
  # Get identifiers each of which will get it's own report.
  ids = levels(rate_data$id)
  
  # create build directories if they don't exist
  dir.create(file.path("build", "reports"), showWarnings = FALSE)
  num_dirs_created <- lapply(ids, FUN=create_report_dir, memo_type=memo_type )
  
  # run report generation for each id
  successes <- sapply(ids, FUN=generate_report, memo_type=memo_type)
  return(sum(successes))
}

clc_input <- file.path("build","performance_clc.rdata")
hbpc_input <- file.path("build","performance_hbpc.rdata")

if(file.exists(clc_input)){
  cat("Generating CLC Reports\n")
  num_reports <- run_report_for_all_ids(clc_input, "clc")
  cat("Created ", num_reports, " CLC reports.")
}

if(file.exists(hbpc_input)){
  cat("Generating HBPC Reports\n")
  num_reports <- run_report_for_all_ids(hbpc_input, "hbpc")
  cat("Created ", num_reports, " HBPC reports.")
}





