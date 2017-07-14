library(tidyr)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(ggthemes)

# Generate the plot for a hit categories performance metric
# This script contains two utility functions:
#   * Transform data for plotting convenience
#   * Produce plot

make_hit_category_plot_data <- function(input_data){

  gathered <- gather(input_data, key="event", value="count", cat_1, cat_2, cat_3) 
  
  # Convert key column (title of former columns) to a factor with the specified order of values
  #   Specify in reverse order so that the geom_text and geom_col line up.
  #   Something screwing based on the values of the factor levels
  gathered$event <- factor(gathered$event, levels = c("cat_3", "cat_2", "cat_1"))
  
  # Create a column of data where the counts that are zero are replaced with NA
  #   This column will be used for the text labels so that 0's aren't drawn on the top of the bar.
  gathered$count_na_zero <- replace(gathered$count, gathered$count == 0, NA)
  
  return(gathered)
}

generate_hit_category_plot <- function(plot_data){
  # cat_1 is before
  # cat_2 is week
  # cat_3 is after
  plot.colors = c(cat_1 = "#aaccff", cat_2 = "#88eeaa", cat_3 = "#ffee88")  
  plot.title <- "How close to the time of admission were goals of care \nconversations documented?"
  hit_plot <- ggplot(plot_data, aes(x = timepoint, y = count)) +
    geom_col(aes(fill = event)) +
    geom_text(size = 4,
              aes(label = count_na_zero),
              position = position_stack(vjust = 0.5))   +
    labs(title = plot.title, x = " ", y = "Veterans admitted") +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      legend.title = element_blank()
    ) +
    scale_fill_manual(
      values = plot.colors,
      breaks = c("cat_3", "cat_2", "cat_1"),
      labels = c("8 to 30 days after", "0 to 7 days after","Before admission")
    )
    
  return(hit_plot)
}
