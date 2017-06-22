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
if(exists("clc_summ") == FALSE || is.data.frame(clc_summ) == FALSE){
  print("No data frame named clc_summ in rdata.")
  quit(save="no", status=13)
}

# Check that the header is as expected 
expected_vars <- c("fy","quart","sta6a","WardSID","trtsp_1", "WardLocationName","_TYPE_","_FREQ_",
  "goc_7","goc_14","goc_30","goc_pre90","goc_pre","goc_none","goc_post30","goc_post","trt_spec")
expected_vars_count <- length(expected_vars)

# Expect 17 variables
cat("Expected:", expected_vars_count, "encountered:", length(clc_summ),"\n")
if(length(clc_summ) != expected_vars_count){
  print("Unexpected number of variables!")
  quit(save="no", status=13)
}
  
# Check that the header is as expected 
expected_fields <- c("timeStamp","elapsed","label","responseCode","responseMessage","threadName","dataType","success","bytes",
                     "grpThreads","allThreads","Latency")
expected_field_count <- length(expected_fields)
header_line <- readLines(input_file,n=1)
header_fields <- unlist(strsplit(header_line,","))

cat("Header check:\n")
cat("Expected:", expected_field_count, "encountered:", length(header_fields),"\n")
if(length(header_fields) != expected_field_count){
  print("Unexpected number of input fields!")
  close(input_file)
  quit(save="no", status=10)
}
