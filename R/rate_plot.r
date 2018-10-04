#' @title Rate Plot
#' @description Create a rate plot figure.
#' @param plot_data rate plot dataframe
#' @param plot_title string for plot title
#' @param plot_subtitle string for plot subtitle
#' @param y_label string for y-axis label
#' @param line_label legend text for line that represents total admissions
#' @param stack_labels legend text for the numerator and misses values.
#' @import ggplot2
#' @importFrom scales pretty_breaks
#' @export
rate_plot <- function(plot_data, plot_title = "", plot_subtitle="", y_label = "", line_label="", stack_labels=c("") ){
  # Manually selected colors from Viridis Palette
  viridis_colors = c(denominator="#440154FF", "#414487FF", numerator="#2A788EFF", "#22A884FF", misses = "#7AD151FF", "#FDE725FF")
  
  # Check for extra columns to be used as faceting factors:
  extra_colnames <- rate_extra_colnames(names(plot_data))
  
  # Set upper limit to 10 or max(count) whichever is higher.
  ulim <- ifelse(max(plot_data$denominator) < 10, 10, max(plot_data$denominator))
  
  g <- ggplot(plot_data, aes(x = timepoint, y = count, group = event)) +
    geom_col(aes(fill = event)) +
    geom_text(size = 4,
              aes(label = count_label),
              position = position_stack(vjust = 0.5))   +
    geom_point(aes(y = denominator, color = "denominator")) +
    geom_line(data = plot_data, aes(
      x = timepoint,
      y = denominator,
      color = "denominator"
    )) +
    labs(title = plot_title, 
         subtitle = plot_subtitle,
         x = "", y = y_label) +
    scale_y_continuous(breaks=pretty_breaks(), limits=c(0,ulim)) +
    scale_x_date(date_labels = "%Y %b") +
    scale_colour_manual(
      values = viridis_colors,
      breaks = c("denominator"),
      labels = c(line_label)
    ) +
    scale_fill_manual(
      values = viridis_colors,
      breaks = c("misses", "numerator"),
      labels = stack_labels
    ) +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      legend.title = element_blank(),
      legend.position = "top"
    ) +
    guides(colour = guide_legend(order = 1)) 
  # Add facet wrap if faceting columns are avaialble
  if(length(extra_colnames) > 0) {
    g <- g + facet_wrap(extra_colnames, nrow = 2, scales = "free")
  }
  return(g)
}

#' @title  Rate Extra Colnames
#' @description set diff of column names in plot data with expected names
#' @describeIn Rate Plot
rate_extra_colnames <- function(cnames){
  expected_names <- c('id', 'timepoint', 'event', 'count', 'limit', 'count_label', 'denominator')
  setdiff(cnames, expected_names)
}