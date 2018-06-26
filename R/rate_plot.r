#' @title Rate Plot
#' @description Create a rate plot figure.
#' @param plot_data rate plot dataframe
#' @param plot_title string for plot title
#' @param y_label string for y-axis label
#' @param line_label legend text for line that represents total admissions
#' @param stack_labels legend text for the numerator and misses values.
#' @import ggplot2
#' @importFrom scales pretty_breaks
#' @export
rate_plot <- function(plot_data, plot_title = "", y_label = "", line_label="", stack_labels=c("") ){
  # Manually selected colors from Viridis Palette
  viridis_colors = c(denominator="#440154FF", "#414487FF", numerator="#2A788EFF", "#22A884FF", misses = "#7AD151FF", "#FDE725FF")
  
  # Set upper limit to 10 or max(count) whichever is higher.
  ulim <- ifelse(max(plot_data$denominator) < 10, 10, max(plot_data$denominator))
  
  ggplot(plot_data, aes(x = timepoint, y = count, group = event)) +
    geom_col(aes(fill = event)) +
    geom_text(size = 4,
              aes(label = count_label),
              position = position_stack(vjust = 0.5))   +
    geom_point(aes(y = denominator, color = "denominator")) +
    geom_line(data = plot_data, aes(
      x = as.factor(timepoint),
      y = denominator,
      color = "denominator"
    )) +
    labs(title = plot_title, x = " ", y = y_label) +
    scale_y_continuous(breaks=pretty_breaks(), limits=c(0,ulim)) +
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
      legend.title = element_blank()
    ) +
    guides(colour = guide_legend(order = 1))
}