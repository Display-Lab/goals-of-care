library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)

# Generate the plot for a batting average type performance metric

# Get command line args entered by the user
options <- commandArgs(TRUE)

# If not given a file name, assume the input is build/perf.rdata
if(length(options)==0) {
  input_filename <- file.path("build","perf.rdata")
}else{
  input_filename <- options[1]
}

load(input_filename)

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
gathered <- gather(perf_data, key="event", value="count", misses, hits) 

# Convert key column (title of former columns) to a factor with the specified order of values
gathered$event = factor(gathered$event, levels = c("misses","hits"))
plot.colors = c(total_obs="#000000", hits = "#4286f4", misses = "#e8e8e8")

# Manually specify a single identifier (currently location) to futher filter data.
# TODO: subsequent iterations will generate plot for each identfier
plot_data <- filter(gathered, location == "607")

# Specify the plot using grammar of graphics
perf_plot <- ggplot(plot_data, aes(x=timepoint, y = count, group=event)) +
  geom_col(stat = "identity", aes(fill = event)) + 
  labs(title="How many newly admitted Veterans have a documented \ngoals of care conversation?", x = " ", y = "Veterans admitted") +
  geom_text(size = 4, aes(label = count),
  position = position_stack( vjust = 0.5))   +
  geom_point(aes(y=total_obs,color="total_obs")) + 
  geom_line( data = plot_data, 
  aes(x = as.numeric(timepoint), y = total_obs, color = "total_obs")) +
  scale_colour_manual(values = plot.colors, breaks = c("total_obs"), labels = c("Newly admitted \nveterans")) +
  scale_fill_manual(values = plot.colors, breaks = c("goc_none","goc_done"), labels = c("Not documented", "Documented")) + 
  theme(panel.grid.major = element_blank(),
       panel.grid.minor = element_blank(),
       panel.border = element_blank(),
       panel.background = element_blank(),
       legend.title = element_blank()
       ) + 
  guides(colour = guide_legend(order = 1))
  
# Generate filename based on identifier
plot_filename <- paste0("607", ".png")

ggsave(plot_filename, plot=perf_plot, device="png", "build")
