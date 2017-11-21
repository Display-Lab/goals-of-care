library(tidyr)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(ggthemes)
library(scales)

# Generate the plot for a rate type performance metric
# This script contains two utility functions:
#   * Transform data for plotting convenience
#   * Produce plot


# Hueristic for determining the lower limit of plottable number characters given a vector of counts
lower_print_lim <- function(x){ floor(sum(x)/10) }

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
  
  # Calculate the max digit per ID that should be plotted to avoid overplotting when the height
  #   of the bar is less than that of the plotted numeral.
  count_limits <- gathered %>%
    group_by(id) %>%
    summarise(limit = lower_print_lim(max(denominator)))
  
  # Create a column count_label with NA for counts that are less than the count limit for the id.
  plot_data <- gathered %>% 
    left_join(count_limits, by="id")  %>%
    mutate(
      count_label = case_when(
        count > limit ~ count,
        count <= limit ~ as.numeric(NA)
      )
    )
  
  return(plot_data)
}

generate_rate_plot <- function(plot_data, plot_title = "", y_label = "", line_label="", stack_labels=c("") ){
  # Manually selected colors from Viridis Palette
  viridis_colors = c(denominator="#440154FF", "#414487FF", numerator="#2A788EFF", "#22A884FF", misses = "#7AD151FF", "#FDE725FF")
  
  # Specify the plot using grammar of graphics
  plot <-
    ggplot(plot_data, aes(x = timepoint, y = count, group = event)) +
    geom_col(aes(fill = event)) +
    geom_text(size = 4,
              aes(label = count_label),
              position = position_stack(vjust = 0.5))   +
    geom_point(aes(y = denominator, color = "denominator")) +
    geom_line(data = plot_data, aes(
      x = as.numeric(timepoint),
      y = denominator,
      color = "denominator"
    )) +
    labs(title = plot_title, x = " ", y = y_label) +
    scale_y_continuous(breaks=pretty_breaks()) +
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
  
  return(plot)
}
