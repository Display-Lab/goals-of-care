#' @title Category Plot Data
#' @description Transform rate data to rate plot data. Assumes all numeric columns are count data. Will group by id and timepoint.
#' Other columns are preserved and end up as facets.
#' @param input_data dataframe with "identifier", "timepoint" and category columns,
#' @return dataframe transformed for plotting with category_plot
#' @import dplyr
#' @importFrom tidyr gather
#' @importFrom purrr map_lgl
#' @export
category_plot_data <- function(input_data){
  # Assume all numeric columns are category count columns
  cat_cols <- names(input_data)[purrr::map_lgl(input_data, is.numeric)]
  gathered <- gather(input_data, key="event", value="count", cat_cols) 
  
  # Convert key column (title of former columns) to a factor with the specified order of values
  #   Specify in reverse order so that the geom_text and geom_col legends are in same order.
  rev_levels <- sort(unique(gathered$event), decreasing=TRUE)
  gathered$event <- factor(gathered$event, levels = rev_levels)
  
  # Calculate the max digit per ID that should be plotted to avoid overplotting when the height
  #   of the bar is less than that of the plotted numeral.
  non_cat_cols <- setdiff(colnames(input_data), cat_cols) 
  group_cols <- setdiff(colnames(input_data), c(cat_cols, 'timepoint'))
  
  count_limits <- gathered %>%
    group_by_at(.vars=non_cat_cols) %>%
    summarize(t_lim=lower_print_lim(count) ) %>%
    group_by_at(.vars=group_cols) %>%
    summarize(limit=max(t_lim))
  
  # Create a column count_label with NA for counts that are less than the count limit for the id.
  gathered %>% 
    left_join(count_limits, by=NULL)  %>%
    mutate(
      trtsp_1 = recode(trtsp_1, 
                       "Long-Term NH Care"="Long-Term Care Residents", 
                       "Short-Term NH Care"="Short-Stay Patients"),
      count_label = case_when(
        count > limit ~ count,
        count <= limit ~ as.numeric(NA)
      )
    )
}

#' @title Category Plot Table Data
#' @description Transform category plot data for printing in a report table
#' @param plot_data dataframe with "identifier", "timepoint" and category columns,
#' @return dataframe transformed for printing in an individual report
#' @import dplyr
#' @export
category_plot_table_data <- function(plot_data, cat_labels){
  names(cat_labels) <- paste("cat", 1:length(cat_labels), sep="_")
  plot_data %>%
    mutate(date=format(timepoint, "%Y %b"),
           category=recode(event, !!!cat_labels)) %>%
    select(date, trtsp_1, category, count) %>%
    arrange(trtsp_1, date, category)
}