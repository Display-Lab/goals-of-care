# Filter the input data to get only the rows that will be used susequently

# If not given a file name, assume the input is input/clc.rdata
options <- commandArgs(TRUE)
if(length(options)==0) {
  input_filename <- file.path("input","clc.csv")
}else{
  input_filename <- options[1]
}

input_classes <- c("integer", "integer", "character", "character", "character",  "character", "character",
                            "integer", "integer", "integer", "integer", "integer", "integer",
                            "integer", "integer", "integer", "integer")

input_csv_file <- file.path("input","clc.csv")
clc_summ <- read.csv( input_csv_file, header = TRUE, colClasses = input_classes )


# Create a array of boolean (TRUE) with one value per row in the data
filter <- rep(TRUE, nrow(clc_summ))

# Only use rows with the treatment specialty value of "All Speciialties"
# Logical AND together the base filter with rows for which the condition is true
filter <- filter & clc_summ[,"trtsp_1"] == "All NH Treating Specialties"

# Apply filter to get filtered data
# Subset the data by selecting rows that correspond to TRUE in the filter.
flt_data <- clc_summ[filter,]

# Save filtered data to intermediate directory (build) for later use & examination
output_path = file.path("build","filtered.rdata")
save(flt_data, file = output_path)
