# Calculate performance measurements
#   numerator
#   denominator
#   misses
#   numerator category sums

calc_perf <- function(input_file, id_cols, numer_cols, denom_cols, numer_categories){
  # Assuming input rdata file has a flt_data data frame
  load(input_file)
  
  # Identifier: paste together all the identifier columns
  id <- apply(flt_data[,id_cols, drop=FALSE], 1, FUN=paste, sep="", collapse="")
  
  # Timepoint: synthesize a time point value from the year and quarter columns
  timepoint <- paste(flt_data[,"fy"], "\n", "Q", flt_data[,"quart"], sep="")
  
  # Numerator: sum all numerator columns
  numerator <- rowSums(flt_data[,numer_cols, drop=FALSE])
  
  # Denominator: sum all denominator columns
  denominator <- rowSums(flt_data[,denom_cols, drop=FALSE])
  
  # Misses: difference between denominator and numerator
  misses <- denominator - numerator
  
  # Calculate the categories of numerator
  cat_sums <- lapply(numer_categories, FUN=function(x, df){rowSums(df[,x,drop=FALSE])}, df=flt_data)
  
  # Create data frames of performance measures
  rate_df     <- data.frame(id, timepoint, numerator, misses, denominator)
  category_df <- data.frame(id, timepoint, cat_sums)
  
  return(list(rate_data=rate_df, category_data=category_df))
}

# Performance measure config for CLC
clc_filename <- file.path("build","filtered_clc.rdata")
clc_id_cols <- c("sta6a")
clc_categories <- list("cat_1"=c("goc_pre90","goc_pre"),
                       "cat_2"=c("goc_7"),
                       "cat_3"=c("goc_14","goc_30"))
clc_numer_cols <- c('goc_7', 'goc_14', 'goc_30', 'goc_pre90', 'goc_pre')
clc_denom_cols <- c('goc_7', 'goc_14', 'goc_30', 'goc_pre90', 'goc_pre', 'goc_none')

# Performance measure config for HBPC
hbpc_filename <- file.path("build","filtered_hbpc.rdata")
hbpc_id_cols <- c("hbpc_sta6a")
hbpc_categories <- list("cat_1"=c("numer90","goc_pre"),
                        "cat_2"=c("numer1"),
                        "cat_3"=c("numer2"),
                        "cat_4"=c("numer3"))
hbpc_numer_cols <- c('numer1','numer2','numer3')
hbpc_denom_cols <- c('hbpc')


# Do performance measure calculations for hbpc and clc data

if(file.exists(clc_filename)){
  #calc_clc_performance(clc_filename)
  results = calc_perf(clc_filename, clc_id_cols, clc_numer_cols, clc_denom_cols, clc_categories)
  #Write rate_data and category_data as separate data frames to intermediate file
  rate_data <- results$rate_data
  category_data <- results$category_data
  
  output_path = file.path("build","performance_clc.rdata")
  save(list=c("rate_data","category_data"), file = output_path)
} else {
  cat("No performance data found at: ", clc_filename, "\n")
}

if(file.exists(hbpc_filename)){
  #calc_clc_performance(clc_filename)
  results = calc_perf(hbpc_filename, hbpc_id_cols, hbpc_numer_cols, hbpc_denom_cols, hbpc_categories)
  #Write rate_data and category_data as separate data frames to intermediate file
  rate_data <- results$rate_data
  category_data <- results$category_data
  
  output_path = file.path("build","performance_hbpc.rdata")
  save(list=c("rate_data","category_data"), file = output_path)
} else {
  cat("No performance data found at: ", hbpc_filename, "\n")
}

