#' @title Filter CLC Data
#' @description Handle the special cases of CLC data
#' @param df clc dataframe
#' @return dataframe of filtered CLC data
#' @importFrom stringr str_to_lower
filter_clc_data <- function(df){
  # Covert column names to lower case
  names(df) <- str_to_lower(names(df))
  
  # Filter out all but most recent 8 times
  filter_recent_times(df, 8)
}