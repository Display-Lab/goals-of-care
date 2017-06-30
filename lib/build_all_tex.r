library(knitr)
# Create tex output for each plot

# If not given a file name, assume the input is build/performance.rdata
options <- commandArgs(TRUE)
if(length(options)==0) {
  input_filename <- file.path("build","performance.rdata")
}else{
  input_filename <- options[1]
}

load(input_filename)

generate_clc <- function(id){
  
  # Set the id for which the report will be generated
  selected_id <- id
  
  # Generate a CLC Report passing selected_id via the global env
  knitr_file <- file.path("lib","clc_memo","report_1.Rnw")
  knit(input= knitr_file)
  
  # Clean destination figures directory
  dest_dir <- file.path("build","reports",id)
  
  unlink(file.path(dest_dir, "figure"), recursive = TRUE)
  
  # Move the products of that report to the build/reports directory
  report_filename <- paste0("clc_", id, ".tex")
  file.rename( from="figure",       to=file.path(dest_dir, "figure") )
  file.rename( from="report_1.tex", to=file.path(dest_dir, report_filename) )
  
  # Copy the memo class file into the report directory
  file.copy(from=file.path("lib","clc_memo","texMemo.cls"), to=file.path(dest_dir,"texMemo.cls"))
  
  return(TRUE)
}

# Get identifiers each of which will get it's own report.
ids = levels(hit_rate_data$location)

# create build directories if they don't exist
dir.create(file.path("build", "reports"), showWarnings = FALSE)
num_dirs_created <- lapply(ids, FUN=function(x){ dir.create(file.path("build","reports",x), showWarnings = FALSE)} )

# run report generation for each id
num_reports_created <- lapply(ids, FUN=generate_clc)

