#' @title Process Data
#' @description Process input data frame of clc or hbpc data
#' @param df dataframe of CLC or HBPC data
#' @param envir Environment with constants for processing df.
#' @return list of dataframes: rate and category data frames.
process_data <- function(df, envir){
  # Check for valid inputs
  valid_input <- check_input(df, envir$COL_NAMES)
  if(!valid_input){
    cat("Aborting: Problem with input data.\n")
    return(list())
  }
  
  # Filter input
  if(environmentName(envir) == 'hbpc'){
    dff <- filter_hbpc_data(df)
  }
  
  if(environmentName(envir) == 'clc'){
    dff <- filter_clc_data(df) 
  }
  
  # Calc Performance Measures
  rate_df <- calc_rate_sums(ddf, evir$ID_COLS, evir$NUMER_COLS, envir$DENOM_COLS)
  category_df <- calc_category_sums(ddf, envir$ID_COLS, envir$CATEGORIES)
  
  return(list(rate=rate_df, category=category_df))
}