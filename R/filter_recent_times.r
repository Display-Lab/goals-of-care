#' @title Filter Recent Times
#' @description Trim data to most recent x timepoints and fill in rows for missing times
#' @param df the hbpc or clc data frame
#' @param x number of most recent time points to include
#' @return dataframe of filtered data
#' @import dplyr
filter_recent_times <- function(df, x){
  # Find most recent time point
  max_fy <- max(df$fy)
  max_fy_filter <- df$fy == max_fy
  max_quart <- max( df[max_fy_filter, c('quart')] )
  
  # get list of timepoints to include
  times <- back_timepoints(max_fy, max_quart, x)
  
  # filter using included times
  time_filter <- paste0(df$fy, df$quart) %in% paste0(times$fy, times$quart)
  df_flt <- df[time_filter,]
  
  # Make list of all site & time point combinations that should be present
  options(stringsAsFactors = FALSE)
  site_times <- merge(unique(df$sta6a),times) %>% rename(sta6a=x)
  
  # Fill missing rows with NA for each ID by joining to the site_times table
  df_flt <- df_flt %>% full_join(site_times)
  
  # Replace NAs with 0 for integer columns
  int_cols <- sapply(df_flt, is.integer)
  na_cells <- is.na(df_flt[, int_cols])
  df_flt[,int_cols][na_cells] <- 0
  
  # return filtered dataframe
  return(df_flt)
}
