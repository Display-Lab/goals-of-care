#' @title Filter Recent Times
#' @description Trim data to most recent x timepoints and fill in rows for missing times
#' @param df the data frame that has a date column
#' @param x number of most recent months
#' @return dataframe of filtered data
#' @importFrom lubridate %m-% 
filter_recent_times <- function(df, x){
  threshold <- max(df$date) %m-% months(x-1)
  df[df$date >= threshold,]
}