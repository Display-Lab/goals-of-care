# Script to create synthetic summary data

# Four locations to show: No trend, Random trend, Upward, Downward

#Column names
c_names <- c("fy", "quart", "sta6a", "WardSID", "trtsp_1", "WardLocationName", 
  "_TYPE_", "_FREQ_", "goc_7", "goc_14", "goc_30", "goc_pre90", 
  "goc_pre", "goc_none", "goc_post30", "goc_post", "trt_spec")

c_names <- c("fy", "quart", "sta6a", "WardSID", "trtsp_1", "name", "WardLocationName", 
                             "X_TYPE_", "X_FREQ_", "goc_7", "goc_14", "goc_30", "goc_pre90", 
                             "goc_pre", "goc_none", "goc_post30", "goc_post")

expected_input_classes <- c("integer", "integer", "character", "character", "character",  "character", "character",
                            "integer", "integer", "integer", "integer", "integer", "integer",
                            "integer", "integer", "integer", "integer")


# Function to distribute the hits between five hit categories
# params: total number of samples, number of misses
# return: vector with number of samples in each hit category
distribute_hits <- function(total, misses){
  picks <- sample(1:5, total - misses, replace = TRUE)
  unname(lapply(1:5, function(x, p){ sum(x==p)}, p = picks))
}

# Global total patients for each synthetic data set
total = 104
all_spec = "All NH Treating Specialties"

# No trend site
ntr_data <- rbind(
  setNames(data.frame(2071L, 1L, "nTR", "All Wards", all_spec, "FacName", "All Wards", 4L, total, distribute_hits(total,25), 25, 3L, 3L), c_names),
  setNames(data.frame(2071L, 2L, "nTR", "All Wards", all_spec, "FacName", "All Wards", 4L, total, distribute_hits(total,25), 25, 2L, 4L), c_names),
  setNames(data.frame(2071L, 3L, "nTR", "All Wards", all_spec, "FacName", "All Wards", 4L, total, distribute_hits(total,25), 25, 1L, 5L), c_names),
  setNames(data.frame(2071L, 4L, "nTR", "All Wards", all_spec, "FacName", "All Wards", 4L, total, distribute_hits(total,25), 25, 3L, 3L), c_names),
  setNames(data.frame(2072L, 1L, "nTR", "All Wards", all_spec, "FacName", "All Wards", 4L, total, distribute_hits(total,25), 25, 3L, 3L), c_names),
  setNames(data.frame(2072L, 2L, "nTR", "All Wards", all_spec, "FacName", "All Wards", 4L, total, distribute_hits(total,25), 25, 2L, 4L), c_names),
  setNames(data.frame(2072L, 3L, "nTR", "All Wards", all_spec, "FacName", "All Wards", 4L, total, distribute_hits(total,25), 25, 1L, 5L), c_names),
  setNames(data.frame(2072L, 4L, "nTR", "All Wards", all_spec, "FacName", "All Wards", 4L, total, distribute_hits(total,25), 25, 3L, 3L), c_names))

# Return array of (sum, hits1:5, misses) for some randomly selected number of misses in 1:total
rnd_misses <- function(total){
  misses <- sample(seq(0:total),1)
  c(total, distribute_hits(total, misses), misses)
}

rnd_data <- rbind(
  setNames(data.frame(2071L, 1L, "rTR", "All Wards", all_spec, "FacName", "All Wards", 4L, rnd_misses(total), 3L, 3L), c_names),
  setNames(data.frame(2071L, 2L, "rTR", "All Wards", all_spec, "FacName", "All Wards", 4L, rnd_misses(total), 3L, 3L), c_names),
  setNames(data.frame(2071L, 3L, "rTR", "All Wards", all_spec, "FacName", "All Wards", 4L, rnd_misses(total), 3L, 3L), c_names),
  setNames(data.frame(2071L, 3L, "rTR", "All Wards", all_spec, "FacName", "All Wards", 4L, rnd_misses(total), 3L, 3L), c_names),
  setNames(data.frame(2072L, 1L, "rTR", "All Wards", all_spec, "FacName", "All Wards", 4L, rnd_misses(total), 3L, 3L), c_names),
  setNames(data.frame(2072L, 2L, "rTR", "All Wards", all_spec, "FacName", "All Wards", 4L, rnd_misses(total), 3L, 3L), c_names),
  setNames(data.frame(2072L, 3L, "rTR", "All Wards", all_spec, "FacName", "All Wards", 4L, rnd_misses(total), 3L, 3L), c_names),
  setNames(data.frame(2072L, 3L, "rTR", "All Wards", all_spec, "FacName", "All Wards", 4L, rnd_misses(total), 3L, 3L), c_names))

# Incr site

incr_data <- rbind(
  setNames(data.frame(2071L, 1L, "iTR", "1000000999", all_spec, "FacName", "1161N", 4L, total, distribute_hits(total, 10), 10, 3L, 3L), c_names),
  setNames(data.frame(2071L, 2L, "iTR", "1000000999", all_spec, "FacName", "1161N", 4L, total, distribute_hits(total, 15), 15, 3L, 3L), c_names),
  setNames(data.frame(2071L, 3L, "iTR", "1000000999", all_spec, "FacName", "1161N", 4L, total, distribute_hits(total, 20), 20, 3L, 3L), c_names),
  setNames(data.frame(2071L, 4L, "iTR", "1000000999", all_spec, "FacName", "1161N", 4L, total, distribute_hits(total, 25), 25, 3L, 3L), c_names),
  setNames(data.frame(2072L, 1L, "iTR", "1000000999", all_spec, "FacName", "1161N", 4L, total, distribute_hits(total, 28), 28, 3L, 3L), c_names),
  setNames(data.frame(2072L, 2L, "iTR", "1000000999", all_spec, "FacName", "1161N", 4L, total, distribute_hits(total, 32), 32, 3L, 3L), c_names),
  setNames(data.frame(2072L, 3L, "iTR", "1000000999", all_spec, "FacName", "1161N", 4L, total, distribute_hits(total, 39), 39, 3L, 3L), c_names),
  setNames(data.frame(2072L, 4L, "iTR", "1000000999", all_spec, "FacName", "1161N", 4L, total, distribute_hits(total, 38), 38, 3L, 3L), c_names))

# Decr site
decr_data <- rbind(
  setNames(data.frame(2071L, 1L, "dTR", "1000000888", all_spec, "FacName", "1161J", 4L, total, distribute_hits(total, 33), 33, 3L, 3L), c_names),
  setNames(data.frame(2071L, 2L, "dTR", "1000000888", all_spec, "FacName", "1161J", 4L, total, distribute_hits(total, 28), 28, 3L, 3L), c_names),
  setNames(data.frame(2071L, 3L, "dTR", "1000000888", all_spec, "FacName", "1161J", 4L, total, distribute_hits(total, 23), 23, 3L, 3L), c_names),
  setNames(data.frame(2071L, 4L, "dTR", "1000000888", all_spec, "FacName", "1161J", 4L, total, distribute_hits(total, 15), 15, 3L, 3L), c_names),
  setNames(data.frame(2072L, 1L, "dTR", "1000000888", all_spec, "FacName", "1161J", 4L, total, distribute_hits(total, 12), 12, 3L, 3L), c_names),
  setNames(data.frame(2072L, 2L, "dTR", "1000000888", all_spec, "FacName", "1161J", 4L, total, distribute_hits(total, 10), 10, 3L, 3L), c_names),
  setNames(data.frame(2072L, 3L, "dTR", "1000000888", all_spec, "FacName", "1161J", 4L, total, distribute_hits(total, 5), 5, 3L, 3L), c_names),
  setNames(data.frame(2072L, 5L, "dTR", "1000000888", all_spec, "FacName", "1161J", 4L, total, distribute_hits(total, 0), 0, 3L, 3L), c_names))

# Combine all the data together with expected data frame name for analysis
clc_summ <- rbind(ntr_data, rnd_data, incr_data, decr_data)

# Write to input directory
output_path = file.path("input","clc.csv")
#save(clc_summ, file = output_path)
write.csv(clc_summ, file = output_path, row.names = FALSE)
