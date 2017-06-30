# Pre-process check validity of rdata input file.

# Get command line args entered by the user
options <- commandArgs(TRUE)

# If not given a file name, assume the input is input/clc.rdata
if(length(options)==0) {
  input_filename <- file.path("input","clc.rdata")
}else{
  input_filename <- options[1]
}

load(input_filename)

# Expect data.frame named clc_summ
cat("\nChecking name of data frame from input rdata file.\n")
if(exists("clc_summ") == FALSE || is.data.frame(clc_summ) == FALSE){
  cat("No data frame named clc_summ in rdata.\n")
  quit(save="no", status=13)
} else {
  cat("Found expected data.frame\n")
}

# Check that the header is as expected 
expected_vars <- c("fy","quart","sta6a","WardSID","trtsp_1", "WardLocationName","_TYPE_","_FREQ_",
  "goc_7","goc_14","goc_30","goc_pre90","goc_pre","goc_none","goc_post30","goc_post","trt_spec")
expected_vars_count <- length(expected_vars)

# Expect 17 variables
cat("Checking number of variables in data frame.\n")
cat("Expected:", expected_vars_count, "encountered:", length(clc_summ),"\n")
if(length(clc_summ) != expected_vars_count){
  cat("Unexpected number of variables!\n")
  quit(save="no", status=13)
}

# Check that names of columns matches expected
col_differences <- setdiff(expected_vars, colnames(clc_summ))
if(length(col_differences) == 0){
  cat("Found expected columns.\n")
} else {
  cat("Unexpected columns!\n")
  print(col_differences)
  quit(save="no", status=13)
}
