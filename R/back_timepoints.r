#' @title Back Timepoints
#' @description Create a reference data table with all the backing time points
#'   starting from the given timepoint and stepping backwards.
#' @note Put everything in terms of sum of quarters 
#'   mapping q1 to 0 and q4 to 3 because 2000q4 != 2005
#'   e.g 2000Q1 => 8000, 2001Q4 => 8007 
#' @param fy fiscal year of most recent timepoint
#' @param quart quarter of most recent timepoint
#' @param num number of quarters to go back
#' @return dataframe with list of fy & quart
#' 
back_timepoints <- function(fy, quart, num){
  qsum <- fy * 4 + (quart -1)
  # Go back num quarters
  qsum_min <- qsum - (num - 1)
  # Make vector of qsum values 
  qsum_vec <- seq(from=qsum_min, to=qsum)
  
  # Make vector of fy for each qsum value
  fy_vec <- floor(qsum_vec/4)
  # Make vector of quarter for each qsum value
  quart_vec <- qsum_vec %% 4 + 1
  
  data.frame(fy=fy_vec,quart=quart_vec)
}