#' @title Filter HBPC Data
#' @description Handle the special cases of HBPC data
#' @param df hbpc dataframe
#' @note Rename id column for consistency with clc then filter
#' @return dataframe of filtered HBPC data
#' @import dplyr
#' @importFrom magrittr %>%
filter_hbpc_data <- function(df){
  df %>%
    rename(sta6a=cdw_sta6a) %>%
    filter_recent_times(., 6)
}
