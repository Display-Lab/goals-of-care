#' @title Filter Dementia Data
#' @description Handle the special cases of Dementia data
#' @param df dementia dataframe
#' @return dataframe of filtered Dementia data
#' @importFrom stringr str_to_lower
filter_dementia_data <- function(df){
  names(df) <- str_to_lower(names(df))
  df %>%
    mutate(dementia=ifelse(dementia==1, 'dementia patients', 'all patients')) %>%
    filter_recent_times(., 8)
}