#' @title Lower Print Lim
#' @description Hueristic for determining the lowest number character to print on a bar.
#' @param x vector of counts
lower_print_lim <- function(x){ floor(sum(x)/10) }