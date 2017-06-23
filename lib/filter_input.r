# Filter the input data to get only the rows that will be used susequently

# If not given a file name, assume the input is input/clc.rdata
options <- commandArgs(TRUE)
if(length(options)==0) {
  input_filename <- file.path("input","clc.rdata")
}else{
  input_filename <- options[1]
}

load(input_filename)

# Create a array of boolean (TRUE) with one value per row in the data
filter <- rep(TRUE, nrow(clc_summ))

# Only use rows with the treatment specialty value of "All Speciialties"
# Logical AND together the base filter with rows for which the condition is true
filter <- filter & clc_summ[,"trt_spec"] == "All Specialties"

# Apply filter to get filtered data
# Subset the data by selecting rows that correspond to TRUE in the filter.
flt_data <- clc_summ[filter,]

# Save filtered data to intermediate directory (build) for later use & examination
save(flt_data, file = "build/filtered.rdata")
