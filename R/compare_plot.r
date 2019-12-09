#' @title Compare Plot
#' @description Create a rate plot figure.
#' @param plot_data rate plot dataframe with avg and rate calculated
#' @param plot_title string for plot title
#' @param plot_subtitle string for plot subtitle. may be omitted?
#' @param y_label string for y-axis label
#' @import ggplot2
#' @importFrom scales pretty_breaks percent
#' @export
compare_plot <- function(plot_data, plot_title = "", plot_subtitle="", y_label = ""){
  line_label <- "National Average LST Completion"
  # Manually selected colors from Viridis Palette
  plot_colors = c("#90EE90", "#414487FF",  "#2A788EFF", "#22A884FF",  "#7AD151FF", "#FDE725FF")
  
  # Check for extra columns to be used as faceting and color fill factors:
  extra_colnames <- comp_extra_colnames(names(plot_data))
  extra_color_vals <- c()
  if(length(extra_colnames) > 0){
    extra_color_vals <- unique(plot_data[,extra_colnames])
  }
  
  names(plot_colors) <- c(line_label, extra_color_vals, as.character(unique(plot_data$event)))
  
  # Set upper limit to 1
  ulim <- 1
  
  # Differentiate between no admits and 0% documetnation rate
  zero_denoms <- plot_data$denominator == 0
  plot_data$noadmits_label <- NA
  plot_data$noadmits_label[zero_denoms] <- "no admits"
  
  # indicate 0% when all new admits were not documented.
  zero_nums <- plot_data$count == 0 & plot_data$denominator > 0
  plot_data$counts_label <- NA
  plot_data$counts_label[zero_nums] <- "0%"
  
  g <- ggplot(plot_data, aes(x = timepoint, y = rate)) +
    geom_col(fill=plot_colors[3]) +
    geom_line(aes(y=avg, colour=line_label), size=2 ) +
    geom_text(aes(y=.35, label=noadmits_label), angle=90) +
    geom_text(aes(y=.1, label=counts_label)) +
    labs(title = plot_title,  x = "", y = "", subtitle = plot_subtitle) +
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
      legend.margin=margin(c(1.5,1.5,1.5,1.5), unit="pt"),
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.margin=margin(10,15,0,0,"pt")) +
    guides(colour = guide_legend(order = 1)) 
  # Add facet wrap if faceting columns are avaialble e.g. trtsp_1
  if(length(extra_colnames) > 0) {
    g <- g + facet_wrap(extra_colnames, nrow = 1, scales = "free")
  }
  return(g)
}

#' @title Comparison Extra Column Names
#' @describeIn compare_plot discover extra column names in plot data for comparison plot
comp_extra_colnames <- function(cnames){
  expected_names <- c('id', 'timepoint', 'event', 'count', 'limit', 'count_label', 'denominator', 
                      'uquant', 'lquant', 'rate', 'mean', 'avg')
  setdiff(cnames, expected_names)
}