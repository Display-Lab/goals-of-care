# Script to create synthetic HBPC summary data

# Four locations to show: HBPC No Trend, HBPC Random trend, HBPC Upward, HBPC Downward

#Column names
c_names <- c("fy", "quart", "sta6a",
             "hbpc", "goc_1", "goc_2", "goc_3", 
             "goc_pre90", "goc_pre91")

expected_input_classes <- c("integer", "integer", "character", 
                            "integer", "integer",  "integer", "integer","integer",
                            "integer",  "integer")

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
  setNames(data.frame(2071L, 1L, "hbpcNTR", total, distribute_nums(total,21)), c_names),
  setNames(data.frame(2071L, 2L, "hbpcNTR", total, distribute_nums(total,21)), c_names),
  setNames(data.frame(2071L, 3L, "hbpcNTR", total, distribute_nums(total,21)), c_names),
  setNames(data.frame(2071L, 4L, "hbpcNTR", total, distribute_nums(total,21)), c_names),
  setNames(data.frame(2072L, 1L, "hbpcNTR", total, distribute_nums(total,21)), c_names),
  setNames(data.frame(2072L, 2L, "hbpcNTR", total, distribute_nums(total,21)), c_names),
  setNames(data.frame(2072L, 3L, "hbpcNTR", total, distribute_nums(total,21)), c_names),
  setNames(data.frame(2072L, 4L, "hbpcNTR", total, distribute_nums(total,21)), c_names))

# Return array of (sum, hits1:5, misses) for some randomly selected number of misses in 1:total
rnd_numerators <- function(total){
  numerator<- sample(seq(0:total),1)
  distribute_nums(total, numerator)
}

# Random data site
rnd_data <- rbind(
  setNames(data.frame(2071L, 1L, "hbpcRND", total, rnd_numerators(total)), c_names),
  setNames(data.frame(2071L, 2L, "hbpcRND", total, rnd_numerators(total)), c_names),
  setNames(data.frame(2071L, 3L, "hbpcRND", total, rnd_numerators(total)), c_names),
  setNames(data.frame(2071L, 4L, "hbpcRND", total, rnd_numerators(total)), c_names),
  setNames(data.frame(2072L, 1L, "hbpcRND", total, rnd_numerators(total)), c_names),
  setNames(data.frame(2072L, 2L, "hbpcRND", total, rnd_numerators(total)), c_names),
  setNames(data.frame(2072L, 3L, "hbpcRND", total, rnd_numerators(total)), c_names),
  setNames(data.frame(2072L, 4L, "hbpcRND", total, rnd_numerators(total)), c_names))

# Incr site
incr_data <- rbind(
  setNames(data.frame(2071L, 1L, "hbpcINC", total, distribute_nums(total,5)), c_names),
  setNames(data.frame(2071L, 2L, "hbpcINC", total, distribute_nums(total,7)), c_names),
  setNames(data.frame(2071L, 3L, "hbpcINC", total, distribute_nums(total,9)), c_names),
  setNames(data.frame(2071L, 4L, "hbpcINC", total, distribute_nums(total,10)), c_names),
  setNames(data.frame(2072L, 1L, "hbpcINC", total, distribute_nums(total,12)), c_names),
  setNames(data.frame(2072L, 2L, "hbpcINC", total, distribute_nums(total,13)), c_names),
  setNames(data.frame(2072L, 3L, "hbpcINC", total, distribute_nums(total,18)), c_names),
  setNames(data.frame(2072L, 4L, "hbpcINC", total, distribute_nums(total,24)), c_names))

# Decr site
decr_data <- rbind(
  setNames(data.frame(2071L, 1L, "hbpcDCR", total, distribute_nums(total,21)), c_names),
  setNames(data.frame(2071L, 2L, "hbpcDCR", total, distribute_nums(total,19)), c_names),
  setNames(data.frame(2071L, 3L, "hbpcDCR", total, distribute_nums(total,17)), c_names),
  setNames(data.frame(2071L, 4L, "hbpcDCR", total, distribute_nums(total,16)), c_names),
  setNames(data.frame(2072L, 1L, "hbpcDCR", total, distribute_nums(total,14)), c_names),
  setNames(data.frame(2072L, 2L, "hbpcDCR", total, distribute_nums(total,12)), c_names),
  setNames(data.frame(2072L, 3L, "hbpcDCR", total, distribute_nums(total,9)), c_names),
  setNames(data.frame(2072L, 4L, "hbpcDCR", total, distribute_nums(total,5)), c_names))

# Combine all the data together
summ <- rbind(ntr_data, rnd_data, incr_data, decr_data)

# Write to input directory
output_path = file.path("input","hbpc.csv")
write.csv(summ, file = output_path, row.names = FALSE)
