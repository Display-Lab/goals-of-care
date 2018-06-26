#' @title Timespan Text
#' @description Utility function to convert timepoints factor into string for title. 
#' @param timepoints character vector of all in form of "2018\\nQ3"
timespan_text <- function(timepoints){
  ret <- paste(first(timepoints), last(timepoints), sep=" - ")
  ret <- gsub('\\\n','', ret)
}