library(tidyr)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(ggthemes)

# Generate the plot for a rate type performance metric
# This script contains two utility functions:
#   * Transform data for plotting convenience
#   * Produce plot

# Given data frame with "identifier", "numerator" and "misses" columns,
#  return data frame transformed for plotting 
make_rate_plot_data <- function(input_data){
  # Convert multiple columns into two columns of key-value pairs
  #  where the keys are the column titles and the values are those of the former columns
  # For example, the row:
  #
  # location timepoint numerator misses denominator
  # 556      2019 Q3   30        10     40 
  # 
  # Will become two rows after the gather operation with the parameters used in this script.
  #
  # location timepoint denominator event      count
  # 556      2015 Q1   40          misses     10
  # 556      2015 Q1   40          numerator  30
  gathered <- gather(input_data, key="event", value="count", misses, numerator) 
  
  # Convert key column (title of former columns) to a factor with the specified order of values
  gathered$event = factor(gathered$event, levels = c("misses","numerator"))
  
  # Create a column of data where the counts that are zero are replaced with NA
  #   This column will be used for the text labels so that 0's aren't drawn on the top of the bar.
  gathered$count_na_zero <- replace(gathered$count, gathered$count == 0, NA)
  
  return(gathered)
}

generate_rate_plot <- function(plot_data){
  plot.colors = c(denominator="#000000", numerator = "#4286f4", misses = "#e8e8e8")
  
  # Specify title of the plot
  plot_title <- "How many total newly admitted Veterans have a documented \ngoals of care conversation?" 
  
  # Specify the plot using grammar of graphics
  plot <-
    ggplot(plot_data, aes(x = timepoint, y = count, group = event)) +
    geom_col(stat = "identity", aes(fill = event)) +
    geom_text(size = 4,
              aes(label = count_na_zero),
              position = position_stack(vjust = 0.5))   +
    geom_point(aes(y = denominator, color = "denominator")) +
    geom_line(data = plot_data, aes(
      x = as.numeric(timepoint),
      y = denominator,
      color = "denominator"
    )) +
    labs(title = plot_title, x = " ", y = "Veterans admitted") +
    scale_colour_manual(
      values = plot.colors,
      breaks = c("denominator"),
      labels = c("Newly admitted \nveterans")
    ) +
    scale_fill_manual(
      values = plot.colors,
      breaks = c("misses", "numerator"),
      labels = c("Not documented", "Documented")
    ) +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      legend.title = element_blank()
    ) +
    guides(colour = guide_legend(order = 1))
  
  return(plot)
}
