#' @title Calculate Rate Sums
#' @param flt_data dataframe of filtered data
#' @param id_cols names of columns to use as id
#' @param numer_cols names of columns used in numerators
#' @param denom_cols names of columns used in denominators
#' @return dataframe of numerator and denominator sums
calc_rate_sums <- function(flt_data, id_cols, numer_cols, denom_cols){
  id          <- apply(flt_data[,id_cols, drop=FALSE], 1, FUN=paste, sep="", collapse="")
  timepoint   <- paste(flt_data$fy, "\n", "Q", flt_data$quart, sep="")
  numerator   <- rowSums(flt_data[,numer_cols, drop=FALSE])
  denominator <- rowSums(flt_data[,denom_cols, drop=FALSE])
  misses      <- denominator - numerator
  
  data.frame(id, timepoint, numerator, misses, denominator)
}
