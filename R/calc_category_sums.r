#' @title Calculate Category Sums
#' @description Sum the counts for categories of numerators.  This function assumes there is only a single denominator.
#' @param flt_data dataframe of filtered data
#' @param id_cols names of columns to use as id
#' @param numer_categories list of numerator groupings each containing a vector of names of column names which belong to the numerator group.
#' @param preserve_cols names of columns to be preserved for subsquent use in faceting for further processing.
#' @return dataframe of category sums
calc_category_sums <- function(flt_data, id_cols, numer_categories, preserve_cols){
  id          <- apply(flt_data[,id_cols, drop=FALSE], 1, FUN=paste, sep="", collapse="")
  timepoint   <- flt_data$report_month
  cat_sums    <- lapply(numer_categories, FUN=function(x, df){rowSums(df[,x,drop=FALSE])}, df=flt_data)
  preserved   <- as.data.frame(flt_data[, preserve_cols])
  names(preserved) <- preserve_cols
  
  data.frame(id, timepoint, cat_sums, preserved)
}
