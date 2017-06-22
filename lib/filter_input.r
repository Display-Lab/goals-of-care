library(tidyverse, warn.conflicts = FALSE)

# If not given a file name, assume the input is input/clc.rdata
options <- commandArgs(TRUE)
if(length(options)==0) {
  input_filename <- file.path("input","clc.rdata")
}else{
  input_filename <- options[1]
}

load(input_filename)

# Filter input data
filter <- rep(TRUE, nrow(clc_summ))

# Only use rows with the treatment specialty value of "All Speciialties"
filter <- filter & clc_summ[,"trt_spec"] == "All Specialties"

# Apply filter to get filtered data
flt_data <- clc_summ[filter,]

# Save filtered data to intermediate directory (build) for later use & examination
save(flt_data, file = "build/filtered.rdata")
