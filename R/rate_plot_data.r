#' @title Rate Plot Data
#' @description Transform rate data to rate plot data. 
#' @param input_data dataframe with "identifier", "numerator" and "misses" columns,
#' @return dataframe transformed for plotting with rate_plot
#' @import dplyr
#' @importFrom tidyr gather
#' @export
rate_plot_data <- function(input_data){
  gathered <- gather(input_data, key="event", value="count", misses, numerator) 
  
  # Convert key column (title of former columns) to a factor with the specified order of values
  gathered$event = factor(gathered$event, levels = c("misses","numerator"))
  
  # Calculate the max digit per ID that should be plotted to avoid overplotting when the height
  #   of the bar is less than that of the plotted numeral.
  count_limits <- gathered %>%
    group_by(id) %>%
    summarise(limit = lower_print_lim(max(denominator)))
  
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
