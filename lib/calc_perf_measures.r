# Calculate performance measurements

# If not given a file name, assume the input is build/filtered.rdata
options <- commandArgs(TRUE)
if(length(options)==0) {
  input_filename <- file.path("build","filtered.rdata")
}else{
  input_filename <- options[1]
}

load(input_filename)

# Columns that summed together constitute hits
hits_cols <- c('goc_7', 'goc_14', 'goc_30', 'goc_pre90', 'goc_pre')

# Columns that summed together constitute misses
misses_cols <- c('goc_none')

# If more than one column, sum the values accross rows to condense into a single column

# For each row, sum the values accross the numerator columns to get a single numerator vector.
# Use drop=FALSE in subsetting to allow for single column being selected and passed to rowSums.
hits <- rowSums(flt_data[,hits_cols, drop=FALSE])

# For each row, sum the values accross the denominator columns to get a single denominator vector
misses <- rowSums(flt_data[,misses_cols, drop=FALSE])

# The total observations are hits + misses
total_obs <- hits + misses

# Synthesize a time point value from the year and quarter columns
timepoint <- paste(flt_data[,"fy"], "\n", "Q", flt_data[,"quart"], sep="")

# Location
location <- flt_data[,"sta6a"]

# Create data frame of performance measures
perf_data <- data.frame(location, timepoint, hits, misses, total_obs)

# Write perf data to intermediate directory
output_path = file.path("build","perf.rdata")
save(perf_data, file = output_path)
