library(tidyr)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(ggthemes)
library(viridis)
library(scales)

# Generate the plot for a categories performance metric
# This script contains two utility functions:
#   * Transform data for plotting convenience
#   * Produce plot
make_category_plot_data <- function(input_data){

  # Assume all non-id non-timepoint columns are category columns
  gathered <- gather(input_data, key="event", value="count", -id, -timepoint) 
  
  # Convert key column (title of former columns) to a factor with the specified order of values
  #   Specify in reverse order so that the geom_text and geom_col legends are in same order.
  rev_levels = sort(unique(gathered$event), decreasing=TRUE)
  gathered$event <- factor(gathered$event, levels = rev_levels)
  
  # Create a column of data where the counts that are zero are replaced with NA
  #   This column will be used for the text labels so that 0's aren't drawn on the top of the bar.
  gathered$count_na_zero <- replace(gathered$count, gathered$count == 0, NA)
  
  return(gathered)
}

generate_category_plot <- function(plot_data, plot_title, y_label, cat_labels){
  plot <- ggplot(plot_data, aes(x = timepoint, y = count)) +
    geom_col(aes(fill = event)) +
    geom_text(size = 4,
              aes(label = count_na_zero, colour=event),
              position = position_stack(vjust = 0.5),
              show.legend = F)   +
    scale_y_continuous(breaks=pretty_breaks()) +
    labs(title = plot_title, x = " ", y = y_label) +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      legend.title = element_blank()
    ) +
    scale_fill_viridis(
      discrete = TRUE,
      breaks = levels(plot_data$event),
      labels = cat_labels
    ) +
    scale_color_viridis(
      discrete = TRUE,
      breaks = levels(plot_data$event),
      labels = cat_labels,
      direction = -1
    )
    
  return(plot)
}
