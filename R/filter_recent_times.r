#' @title Filter Recent Times
#' @description Trim data to most recent x timepoints and fill in rows for missing times
#' @param df the hbpc or clc data frame: has fy, month, sta6a 
#' @param x number of most recent months
#' @return dataframe of filtered data
#' @import make_date from lubridate
#' @import %m-% from lubridate
filter_recent_times <- function(df, x){
  # make vector of dates from year and month
  dates <- do.call(c, mapply(lubridate::make_date, df$fy, df$month, SIMPLIFY=F))
  
  # find minimum date going by months
  min_date <- max(dates) %m-% months(x-1)
  time_filter <- dates >= min_date
  
  # filter using included times
  df_flt <- df[time_filter,]
  
  # return filtered dataframe
  return(df_flt)
}