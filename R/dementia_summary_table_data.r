#' @title Dementia Summary Table Data
#' @description Generate data for dementia table
#' @param ctgy_data dementia report category data
#' @return tibble of values 
#' @export
dementia_summary_table_data <- function(ctgy_data){
  ctgy_data %>% 
    group_by(trtsp_1, dementia, timepoint) %>% 
    summarize(all=sum(count),
              new=sum(count[event=='cat_3']),
              old=sum(count[event=='cat_2']),
              any=sum(count[event=='cat_2'|event=='cat_3'])) %>%
    pivot_on(timepoint)
}

#' @title inner_spread
#' @description individual spread operation to be done on each value column.  
#' Excluded other value columns.
#' @note internal function to support pivot_on
#' @describeIn Pivot On
#' @import dplyr
#' @importFrom tidyr spread
inner_spread <- function(vc, pcol_name, data){
  col_names <- c(vc,pcol_name, group_vars(data))
  print(vc)
  
  data %>% 
    select_at(col_names) %>%
    spread(pcol_name, vc) %>% 
    mutate(evt=vc)
}

#' @title Pivot On
#' @description Turn values from pivot column into new columns.  Preserve grouping columns.
#'   Gather value columns under newly created cols.  Add evt column to indicate origin of values.
#' @param .data tibble data
#' @param pcol column to be pivotted on.  Values will be made into new columns via spread.
#' @return tibble of values 
#' @export
pivot_on <- function(.data, pcol){
  print(colnames(.data))
  print(group_vars(.data))
  pcol_name <- deparse(substitute(pcol))
  val_col_names <- dplyr::setdiff(colnames(.data), c(group_vars(.data), pcol_name))
  
  spread_tbls <- lapply(val_col_names, FUN=inner_spread, pcol_name, .data)
  bind_rows(spread_tbls)
}