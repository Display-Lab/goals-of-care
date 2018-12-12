#' @title Dementia Summary Table Data
#' @description Generate data for dementia table
#' @param ctgy_data dementia report category data
#' @return tibble of values 
#' @export
dementia_summary_table_data <- function(ctgy_data){
  summ_data <- dementia_summary_data_calculation(ctgy_data)
  dementia_summary_data_formatting(summ_data)
}

#' @title Dementia Summary Table Data
#' @description Summarize count data for dementia reports table
#' @describeIn Dementia Summary Table Data
dementia_summary_data_calculation <- function(ctgy_data){
  ctgy_data %>% 
    group_by(trtsp_1, dementia, timepoint) %>% 
    summarize('Total number patients'=sum(count),
              "Number with new LST this month"=sum(count[event=='cat_3']),
              "Number with existing LST this month"=sum(count[event=='cat_2']),
              "Number with any LST"=sum(count[event=='cat_2'|event=='cat_3'])) %>%
    pivot_on(timepoint) %>%
    rename_at(.vars=vars(dateish()), .funs=dateify) %>%
    select(evt, everything())
}

#' @title Dementia Summary Table Data
#' @description Rearrange summarized count data for dementia reports table
#' @describeIn Dementia Summary Table Data
dementia_summary_data_formatting <- function(dementia_summ_data){
  # Enforce specific ordering of evt values using factor levels
  ordered_evt_levels <- c("Number with new LST this month",
                          "Number with existing LST this month",
                          "Number with any LST",
                          "Total number residents",
                          "Total number patients")
  
  # Re-arrange and rename data to facilite table display
  dementia_summ_data %>%
    arrange(trtsp_1, dementia, evt) %>%
    ungroup %>%
    mutate(rgroup=case_when(
             trtsp_1=="Long-Term Care Residents" ~ paste(trtsp_1,": ", sub('Patients', 'Residents', dementia), sep=''),
             trtsp_1=="Short-Stay Patients" ~ paste(trtsp_1,": ",dementia, sep='')
           ),
           evt = case_when(
             trtsp_1=="Long-Term Care Residents" & evt == "Total number patients" ~ "Total number residents",
             TRUE ~ evt), 
           evt = factor(evt, ordered_evt_levels, ordered=TRUE)) %>%
    arrange(rgroup,evt) %>%
    select( c(-dementia, -trtsp_1) ) %>%
    rename_at(.vars=vars(dateish()), .funs=dateify) %>%
    select( rgroup, evt, everything() )
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
  pcol_name <- deparse(substitute(pcol))
  val_col_names <- dplyr::setdiff(colnames(.data), c(group_vars(.data), pcol_name))
  
  spread_tbls <- lapply(val_col_names, FUN=inner_spread, pcol_name, .data)
  bind_rows(spread_tbls)
}

#' @title Dateify
#' @description custom formatting function for dementia summary table column names
#' @describeIn Dementia Summary Table Data
#' @param x character vector of names to format
#' @return character vector of names formatted like 2018 Apr 
dateify <- function(x){ format(as.Date(x), format="%Y %b") }
  
#' @title Dateish
#' @description Determine which column names are date strings   
#' @describeIn Dementia Summary Table Data
#' @param x character vector of column names
#' @return vector of indecies 
dateish <- function(vars=tidyselect::peek_vars()){
  parsed <- suppressWarnings(sapply(X=vars, FUN=lubridate::as_date))
  isdates <- !is.na(parsed)
  return(which(isdates))
}
