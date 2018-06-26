#' @title Filter Recent Times
#' @description Trim data to most recent x timepoints and fill in rows for missing times
#' @param df the hbpc or clc data frame: has fy, quart, sta6a 
#' @param x number of most recent time points to include
#' @return dataframe of filtered data
#' @import dplyr
filter_recent_times <- function(df, x){
  # get list of timepoints to include
  times <- backtimes_from_latest(df,x) 
  
  # filter using included times
  time_filter <- paste0(df$fy, df$quart) %in% paste0(times$fy, times$quart)
  df_flt <- df[time_filter,]
  
  # return filtered dataframe
  return(df_flt)
}

#' @title Back Times from Latest
#' @param df input data frame with fy, quart columns 
#' @describeIn Filter Recent Times
#' @description Find most recent fy and quart, then count backward x quarters
#' @return dataframe with columns fy and quart that lists x timepoints including the max from df
backtimes_from_latest <- function(df, x){
  # Find most recent time point
  max_fy <- max(df$fy)
  max_fy_filter <- df$fy == max_fy
  max_quart <- max( df[max_fy_filter, c('quart')] )
  
  back_timepoints(max_fy, max_quart, x)
}

# Extracted logic to back fill in times when there isn't a trtsp involved
# Not currently used
fill_times <- function(df, x){
  # Find most recent time point
  max_fy <- max(df$fy)
  max_fy_filter <- df$fy == max_fy
  max_quart <- max( df[max_fy_filter, c('quart')] )
  
  # get list of timepoints to include
  times <- back_timepoints(max_fy, max_quart, x)
  
  # Make list of all site & time point combinations that should be present
  options(stringsAsFactors = FALSE)
  site_times <- merge(unique(df$sta6a),times) %>% rename(sta6a=x)
  
  # Fill missing rows with NA for each ID by joining to the site_times table
  df_filled <- df %>% full_join(site_times)
  
  # Replace NAs with 0 for integer columns
  int_cols <- sapply(df_filled, is.integer)
  na_cells <- is.na(df_filled[, int_cols])
  df_filled[,int_cols][na_cells] <- 0
  return(df_filled)
}
