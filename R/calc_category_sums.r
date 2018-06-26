#' @title Calculate Category Sums
#' @param flt_data dataframe of filtered data
#' @param id_cols names of columns to use as id
#' @param numer_categories names of columns grouped by category
#' @return dataframe of category sums
calc_category_sums <- function(flt_data, id_cols, numer_categories, group_cols){
  id          <- apply(flt_data[,id_cols, drop=FALSE], 1, FUN=paste, sep="", collapse="")
  timepoint   <- paste(flt_data$fy, "\n", "Q", flt_data$quart, sep="")
  cat_sums    <- lapply(numer_categories, FUN=function(x, df){rowSums(df[,x,drop=FALSE])}, df=flt_data)
  grouping    <- flt_data[, group_cols]
  
  data.frame(id, timepoint, cat_sums, grouping)
}
