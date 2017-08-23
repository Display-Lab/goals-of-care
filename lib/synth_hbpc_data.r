# Script to create synthetic HBPC summary data

# Four locations to show: HBPC No Trend, HBPC Random trend, HBPC Upward, HBPC Downward

#Column names
c_names <- c("fy", "quart", "hbpc_sta6a",
             "hbpc", "numer1", "numer2", "numer3", "numer90", "goc_pre", "denom90") 

expected_input_classes <- c("integer", "integer", "character", rep("integer",7))

# Function to distribute the numerator values between five numerator columns
# params: total number of samples, total numerator
# return: vector with number of samples in each numerator column
distribute_nums <- function(total, numerator){
  picks <- sample(1:5, numerator, replace = TRUE)
  unname(lapply(1:5, function(x, p){ sum(x==p)}, p = picks))
}

# Global total patients for each synthetic data set
total = 30

# No trend site
ntr_data <- rbind(
  setNames(data.frame(2071L, 1L, "nTR", total, distribute_nums(total,21), 0), c_names),
  setNames(data.frame(2071L, 2L, "nTR", total, distribute_nums(total,21), 0), c_names),
  setNames(data.frame(2071L, 3L, "nTR", total, distribute_nums(total,21), 0), c_names),
  setNames(data.frame(2071L, 4L, "nTR", total, distribute_nums(total,21), 0), c_names),
  setNames(data.frame(2072L, 1L, "nTR", total, distribute_nums(total,21), 0), c_names),
  setNames(data.frame(2072L, 2L, "nTR", total, distribute_nums(total,21), 0), c_names),
  setNames(data.frame(2072L, 3L, "nTR", total, distribute_nums(total,21), 0), c_names),
  setNames(data.frame(2072L, 4L, "nTR", total, distribute_nums(total,21), 0), c_names))

# Return array of (sum, hits1:5, misses) for some randomly selected number of misses in 1:total
rnd_numerators <- function(total){
  numerator<- sample(seq(0:total),1)
  distribute_nums(total, numerator)
}

# Random data site
rnd_data <- rbind(
  setNames(data.frame(2071L, 1L, "rTR", total, rnd_numerators(total), 0), c_names),
  setNames(data.frame(2071L, 2L, "rTR", total, rnd_numerators(total), 0), c_names),
  setNames(data.frame(2071L, 3L, "rTR", total, rnd_numerators(total), 0), c_names),
  setNames(data.frame(2071L, 4L, "rTR", total, rnd_numerators(total), 0), c_names),
  setNames(data.frame(2072L, 1L, "rTR", total, rnd_numerators(total), 0), c_names),
  setNames(data.frame(2072L, 2L, "rTR", total, rnd_numerators(total), 0), c_names),
  setNames(data.frame(2072L, 3L, "rTR", total, rnd_numerators(total), 0), c_names),
  setNames(data.frame(2072L, 4L, "rTR", total, rnd_numerators(total), 0), c_names))

# Incr site
incr_data <- rbind(
  setNames(data.frame(2071L, 1L, "iTR", total, distribute_nums(total,5), 0), c_names),
  setNames(data.frame(2071L, 2L, "iTR", total, distribute_nums(total,7), 0), c_names),
  setNames(data.frame(2071L, 3L, "iTR", total, distribute_nums(total,9), 0), c_names),
  setNames(data.frame(2071L, 4L, "iTR", total, distribute_nums(total,10), 0), c_names),
  setNames(data.frame(2072L, 1L, "iTR", total, distribute_nums(total,12), 0), c_names),
  setNames(data.frame(2072L, 2L, "iTR", total, distribute_nums(total,13), 0), c_names),
  setNames(data.frame(2072L, 3L, "iTR", total, distribute_nums(total,18), 0), c_names),
  setNames(data.frame(2072L, 4L, "iTR", total, distribute_nums(total,24), 0), c_names))

# Decr site
decr_data <- rbind(
  setNames(data.frame(2071L, 1L, "dTR", total, distribute_nums(total,21), 0), c_names),
  setNames(data.frame(2071L, 2L, "dTR", total, distribute_nums(total,19), 0), c_names),
  setNames(data.frame(2071L, 3L, "dTR", total, distribute_nums(total,17), 0), c_names),
  setNames(data.frame(2071L, 4L, "dTR", total, distribute_nums(total,16), 0), c_names),
  setNames(data.frame(2072L, 1L, "dTR", total, distribute_nums(total,14), 0), c_names),
  setNames(data.frame(2072L, 2L, "dTR", total, distribute_nums(total,12), 0), c_names),
  setNames(data.frame(2072L, 3L, "dTR", total, distribute_nums(total,9), 0), c_names),
  setNames(data.frame(2072L, 4L, "dTR", total, distribute_nums(total,5), 0), c_names))

# Combine all the data together
summ <- rbind(ntr_data, rnd_data, incr_data, decr_data)

# Write to input directory
output_path = file.path("input","hbpc.csv")
write.csv(summ, file = output_path, row.names = FALSE)
