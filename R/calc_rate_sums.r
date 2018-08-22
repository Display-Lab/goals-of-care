#' @title Calculate Rate Sums
#' @param flt_data dataframe of filtered data
#' @param id_cols names of columns to use as id
#' @param numer_cols names of columns used in numerators
#' @param denom_cols names of columns used in denominators
#' @param group_cols names of columns to be preserved for further grouping
#' @return dataframe of numerator and denominator sums
calc_rate_sums <- function(flt_data, id_cols, numer_cols, denom_cols, group_cols=NULL){
  # Figure out quosure or scoped approach to stuff this into dplyr
  idvals <- apply(flt_data[,id_cols, drop=FALSE], 1, FUN=paste, sep="", collapse="")
  
  flt_data %>%
    mutate(
      id=idvals,
      timepoint=paste(fy, " ", "M", month, sep=""),
      numerator=rowSums(select_at(., .vars=numer_cols)),
      denominator=rowSums(select_at(., .vars=denom_cols)),
      misses=denominator - numerator) %>%
    select_at(c("id", "timepoint", "numerator", "denominator", "misses", group_cols))
}
