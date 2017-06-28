library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)

# Generate the plot for a hit categories performance metric
# This script contains two utility functions:
#   * Transform data for plotting convenience
#   * Produce plot

make_hit_category_plot_data <- function(input_data){
  # Convert multiple columns into two columns of key-value pairs
  #  where the keys are the column titles and the values are those of the former columns
  # For example, the row:
  #
  # location timepoint hits misses total_obs
  # 556      2019 Q3   30   10     40 
  # 
  # Will become two rows after the gather operation with the parameters used in this script.
  #
  # location timepoint total_obs event      count
  # 556      2015 Q1   40        misses     10
  # 556      2015 Q1   40        hits       30


  gathered <- gather(input_data, key="event", value="count", cat_1, cat_2, cat_3) 
  
  # Convert key column (title of former columns) to a factor with the specified order of values
  #gathered$event = factor(gathered$event, levels = c("misses","hits"))
  gathered$event = as.factor(gathered$event)
  gathered <- mutate(gathered, extrad = ifelse(event == 'cat_2',count,NA))
  return(gathered)
}

generate_hit_category_plot <- function(plot_data){
  # cat_1 is before
  # cat_2 is week
  # cat_3 is after
  
  plot.colors = c(cat_1 = "#4286f4", cat_2 = "#009933", cat_3 = "#ffa700")
  plot.title <- "How close to the time of admission were goals of care \nconversations documented?"
  # Not sure what extrad is doing
  # created a new column just to use two geom text layers
  hit_plot <- ggplot(plot_data, aes(x = timepoint, y = count)) +
    geom_bar(stat = "identity", aes(fill = event)) +
    geom_text(aes(label = extrad, vjust = 1)) +
    geom_text(size = 4,
              aes(label = count),
              position = position_stack(vjust = .5))   +
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
      breaks = c("cat_1", "cat_2", "cat_3"),
      labels = c("Before", "0 to 7 days after", "8 to 30 days after")
    ) +
    guides(colour = guide_legend(order = 1))
    
  return(hit_plot)
}
