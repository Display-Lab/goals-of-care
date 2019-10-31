#' @title Compare Plot
#' @description Create a rate plot figure.
#' @param plot_data rate plot dataframe
#' @param plot_title string for plot title
#' @param plot_subtitle string for plot subtitle. may be omitted?
#' @param y_label string for y-axis label
#' @import ggplot2
#' @importFrom scales pretty_breaks percent
#' @export
compare_plot <- function(plot_data, plot_title = "", plot_subtitle="", y_label = ""){
  ribbon_label <- "VA Interquartile Range (25% - 75%)"
  # Manually selected colors from Viridis Palette
  plot_colors = c("#90EE90", "#414487FF",  "#2A788EFF", "#22A884FF",  "#7AD151FF", "#FDE725FF")
  names(plot_colors) <- c(ribbon_label, unique(plot_data$trtsp_1))
  
  # Check for extra columns to be used as faceting factors:
  extra_colnames <- quant_extra_colnames(names(plot_data))
  
  # Set upper limit to 10 or max(count) whichever is higher.
  #data_max <- max(plot_data$rate, plot_data$uquant)
  #ulim <- ifelse(data_max < 1, 1, data_max)
  ulim <- 1
  
  g <- ggplot(plot_data, aes(x = timepoint, y = rate, group = event)) +
    geom_ribbon(aes(x=timepoint,ymin=lquant,ymax=uquant, fill=ribbon_label))+
    geom_col(aes(fill=trtsp_1)) +
    labs(title = plot_title,  x = "", y = "") +
    scale_y_continuous(breaks=pretty_breaks(), labels=scales::percent, limits=c(0,ulim)) +
    scale_x_date(date_labels = "%Y %b") +
    scale_fill_manual( values=plot_colors,  breaks=names(plot_colors) )+
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      legend.title = element_blank(),
      legend.position = "top",
      axis.text.x = element_text(angle = 45, hjust = 1)
    ) +
    guides(colour = guide_legend(order = 1)) 
  # Add facet wrap if faceting columns are avaialble
  if(length(extra_colnames) > 0) {
    g <- g + facet_wrap(extra_colnames, nrow = 1, scales = "free")
  }
  return(g)
}

#' @description set diff of column names in plot data with expected names
#' @describeIn compare_plot discover extra column names in plot data
quant_extra_colnames <- function(cnames){
  expected_names <- c('id', 'timepoint', 'event', 'count', 'limit', 'count_label', 'denominator', 'uquant', 'lquant', 'rate')
  setdiff(cnames, expected_names)
}