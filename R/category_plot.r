#' @title Category Plot
#' @description Create a category plot figure.
#' @param plot_data category plot dataframe
#' @param plot_title string for plot title
#' @param y_label string for y-axis label
#' @param line_label legend text for line that represents total admissions
#' @param cat_labels legend text for the numerator and misses values.
#' @import ggplot2
#' @importFrom scales pretty_breaks
#' @importFrom viridis scale_colour_viridis
#' @importFrom viridis scale_fill_viridis
#' @export

tmpfunc <- function(x){
  print(x)
}
category_plot <- function(plot_data, plot_title, y_label, cat_labels){
  # Check for extra columns to be used as faceting factors:
  extra_colnames <- category_extra_colnames(names(plot_data))
  
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
  
  data_max <- plot_data %>%
    group_by_at(.vars=c('timepoint', extra_colnames)) %>%
    summarize(sum = sum(count)) %>%
    pull(sum) %>%
    max(na.rm=TRUE)
  
  # Upper limit should not be less than 10
  ulim <- max(data_max, 10)
  
  g <- ggplot(plot_data, aes(x = timepoint, y = count)) +
    geom_col(aes(fill = event)) +
    geom_text(size = 4,
              aes(label = count_label, colour=event),
              position = position_stack(vjust = 0.5),
              show.legend = F)   +
    scale_y_continuous(breaks=pretty_breaks(), limit=c(0,ulim)) +
    scale_x_date(date_labels = "%Y %b", date_breaks = "1 months" ) +
    labs(title = plot_title, x = "", y = y_label) +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      legend.position = "top",
      legend.title = element_blank()
    ) +
    scale_fill_viridis(
      discrete = TRUE,
      breaks = levels(plot_data$event),
      labels = cat_labels
    ) +
    text_label_scale 
  # Add facet wrap if faceting columns are avaialble
  if(length(extra_colnames) > 0) {
    g <- g +facet_wrap(extra_colnames, nrow = 2, scales = "free")
  }
  return(g)
}

# Use a grey for the middle color
#' @title  Odd Palette
#' @describeIn Category Plot
#' @importFrom viridis viridis_pal
odd_palette <- function(n){
  pal <- viridis_pal(direction = -1)(n)
  #extra_color <- first(setdiff(viridis_pal()(n+1), pal))
  extra_color <- "#2D2D2D"
  pal[ceiling(n/2)] <- extra_color
  return(pal)
}

#' @title  Category Extra Colnames
#' @description set diff of column names in plot data with expected names
#' @describeIn Category Plot
category_extra_colnames <- function(cnames){
  expected_names <- c('id', 'timepoint', 'event', 'count', 'limit', 'count_label')
  setdiff(cnames, expected_names)
}