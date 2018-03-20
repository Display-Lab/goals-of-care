library(tidyr)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(ggthemes)
library(viridis)
library(scales)

# Hueristic for determining the lower limit of plottable number characters given a vector of counts
lower_print_lim <- function(x){ floor(sum(x)/10) }

# Generate the plot for a categories performance metric
# This script contains two utility functions:
#   * Transform data for plotting convenience
#   * Produce plot
make_category_plot_data <- function(input_data){

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

# Use a grey for the middle color
odd_palette <- function(n){
  pal <- viridis_pal(direction = -1)(n)
  #extra_color <- first(setdiff(viridis_pal()(n+1), pal))
  extra_color <- "#2D2D2D"
  pal[ceiling(n/2)] <- extra_color
  return(pal)
}

generate_category_plot <- function(plot_data, plot_title, y_label, cat_labels){
  # For odd numbers of categories, use a custom palette for the text label color
  if(length(cat_labels) %% 2 == 0){
    text_label_scale <- scale_colour_viridis(
        discrete = TRUE,
        breaks = levels(plot_data$event),
        option = "C",
        direction = -1
      )
  }else{
    text_label_scale <- scale_colour_manual(
        breaks = levels(plot_data$event),
        values = odd_palette( length(cat_labels) )
      )
  }
  # Get max of sum of stacked counts
  ulim <- plot_data %>%
    group_by(timepoint) %>% 
    summarize(sum=sum(count)) %>%
    pull(sum) %>%
    max(na.rm=T)
  
  # Use 10 as minimum upper limit
  ulim <- ifelse(ulim < 10, 10, ulim)
  
  plot <- ggplot(plot_data, aes(x = timepoint, y = count)) +
    geom_col(aes(fill = event)) +
    geom_text(size = 4,
              aes(label = count_label, colour=event),
              position = position_stack(vjust = 0.5),
              show.legend = F)   +
    scale_y_continuous(breaks=pretty_breaks(), limit=c(0,ulim)) +
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
    text_label_scale
    
  return(plot)
}
