
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
    arrange(trtsp_1, timepoint, category) %>%
    select(date, trtsp_1, category, count)
}