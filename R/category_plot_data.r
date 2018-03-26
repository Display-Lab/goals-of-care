#' @title Category Plot Data
#' @description Transform rate data to rate plot data. 
#' @param input_data dataframe with "identifier", "timepoint" and category columns,
#' @return dataframe transformed for plotting with category_plot
#' @import dplyr
#' @importFrom tidyr gather
category_plot_data <- function(input_data){
  # Assume all non-id non-timepoint columns are category columns
  gathered <- gather(input_data, key="event", value="count", -id, -timepoint) 
  
  # Convert key column (title of former columns) to a factor with the specified order of values
  #   Specify in reverse order so that the geom_text and geom_col legends are in same order.
  rev_levels <- sort(unique(gathered$event), decreasing=TRUE)
  gathered$event <- factor(gathered$event, levels = rev_levels)
  
  # Calculate the max digit per ID that should be plotted to avoid overplotting when the height
  #   of the bar is less than that of the plotted numeral.
  
  count_limits <- gathered %>%
    group_by(id, timepoint) %>%
    summarize(t_lim=lower_print_lim(count) ) %>%
    group_by(id) %>%
    summarize(limit=max(t_lim))
  
  # Create a column count_label with NA for counts that are less than the count limit for the id.
  gathered %>% 
    left_join(count_limits, by="id")  %>%
    mutate(
      count_label = case_when(
        count > limit ~ count,
        count <= limit ~ as.numeric(NA)
      )
    )
}