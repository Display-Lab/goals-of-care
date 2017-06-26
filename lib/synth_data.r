# Script to create synthetic summary data

# Four locations to show: No trend, Random trend, Upward, Downward

#Column names
c_names <- c("fy", "quart", "sta6a", "WardSID", "trtsp_1", "WardLocationName", 
  "_TYPE_", "_FREQ_", "goc_7", "goc_14", "goc_30", "goc_pre90", 
  "goc_pre", "goc_none", "goc_post30", "goc_post", "trt_spec")

v_labels <- c("Fiscal Year",  "Quarter", "CLC Station", "WardSID", "Treating Specialty", "First Ward of CLC Admission", 
              "", "New CLC Admissions", "GOCC 0 - 7 Days post-CLC Admission", 
              "GOCC 8 -14 Days post-CLC Admission", "GOCC 15 - 30 Days post-CLC Admission", 
              "GOCC 90 - 1 Days pre-CLC Admission", "GOCC 91+ Days pre-CLC Admissions", 
              "No GOCC pre-CLC Admission to 31+ days post-Admission or discharge", 
              "GOCC 31+ Days post-CLC Admission", "GOCC post-CLC Discharge (within next quarter)", "")

no_data <- list(fy = integer(0), quart = integer(0), sta6a = character(0), 
                WardSID = integer(0), trtsp_1 = character(0), WardLocationName = character(0), 
                `_TYPE_` = integer(0), `_FREQ_` = integer(0), goc_7 = integer(0), 
                goc_14 = integer(0), goc_30 = integer(0), goc_pre90 = integer(0), 
                goc_pre = integer(0), goc_none = integer(0), goc_post30 = integer(0), 
                goc_post = integer(0), trt_spec = character(0))

# Function to distribute the hits between five hit categories
# params: total number of samples, number of misses
# return: vector with number of samples in each hit category
distribute_hits <- function(total, misses){
  picks <- sample(1:5, total - misses, replace = TRUE)
  sapply(1:5, function(x, p){ sum(x==p)}, p = picks)
}

# Empty data frame
df <- structure(no_data, .Names = c_names, var.labels = v_labels , row.names = character(0), class = "data.frame")

# Global total patients for each synthetic data set
total = 104

# No trend site
ntr_data <- rbind(df,
  c(2071L, 1L, "nTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total,25), 25, 3L, 3L, "All Specialties"),
  c(2071L, 2L, "nTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total,25), 25, 2L, 4L, "All Specialties"),
  c(2071L, 3L, "nTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total,25), 25, 1L, 5L, "All Specialties"),
  c(2071L, 4L, "nTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total,25), 25, 3L, 3L, "All Specialties"),
  c(2071L, 1L, "nTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total,25), 25, 3L, 3L, "All Specialties"),
  c(2071L, 2L, "nTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total,25), 25, 2L, 4L, "All Specialties"),
  c(2071L, 3L, "nTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total,25), 25, 1L, 5L, "All Specialties"),
  c(2071L, 4L, "nTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total,25), 25, 3L, 3L, "All Specialties"))
colnames(ntr_data) <- c_names

# Return sum, hits1:5, misses for some randomly selected number of misses in 1:total
rnd_misses <- function(total){
  misses <- sample(seq(0:total),1)
  c(total, distribute_hits(total, misses), misses)
}

rnd_data <- rbind(df,
  c(2071L, 1L, "rTR", NA_integer_, "NA", "NA", 4L, rnd_misses(total), 3L, 3L, "All Specialties"),
  c(2071L, 2L, "rTR", NA_integer_, "NA", "NA", 4L, rnd_misses(total), 3L, 3L, "All Specialties"),
  c(2071L, 3L, "rTR", NA_integer_, "NA", "NA", 4L, rnd_misses(total), 3L, 3L, "All Specialties"),
  c(2071L, 3L, "rTR", NA_integer_, "NA", "NA", 4L, rnd_misses(total), 3L, 3L, "All Specialties"),
  c(2071L, 1L, "rTR", NA_integer_, "NA", "NA", 4L, rnd_misses(total), 3L, 3L, "All Specialties"),
  c(2071L, 2L, "rTR", NA_integer_, "NA", "NA", 4L, rnd_misses(total), 3L, 3L, "All Specialties"),
  c(2071L, 3L, "rTR", NA_integer_, "NA", "NA", 4L, rnd_misses(total), 3L, 3L, "All Specialties"),
  c(2071L, 3L, "rTR", NA_integer_, "NA", "NA", 4L, rnd_misses(total), 3L, 3L, "All Specialties"))
names(rnd_data) <- c_names

# Incr site

incr_data <- rbind(df,
  c(2071L, 1L, "iTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 10), 10, 3L, 3L, "All Specialties"),
  c(2071L, 2L, "iTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 15), 15, 3L, 3L, "All Specialties"),
  c(2071L, 3L, "iTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 20), 20, 3L, 3L, "All Specialties"),
  c(2071L, 4L, "iTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 25), 25, 3L, 3L, "All Specialties"),
  c(2072L, 1L, "iTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 28), 28, 3L, 3L, "All Specialties"),
  c(2072L, 2L, "iTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 32), 32, 3L, 3L, "All Specialties"),
  c(2072L, 3L, "iTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 39), 39, 3L, 3L, "All Specialties"),
  c(2072L, 4L, "iTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 38), 38, 3L, 3L, "All Specialties"))
names(incr_data) <- c_names

# Decr site
decr_data <- rbind(df,
  c(2071L, 1L, "dTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 33), 33, 3L, 3L, "All Specialties"),
  c(2071L, 2L, "dTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 28), 28, 3L, 3L, "All Specialties"),
  c(2071L, 3L, "dTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 23), 23, 3L, 3L, "All Specialties"),
  c(2071L, 4L, "dTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 15), 15, 3L, 3L, "All Specialties"),
  c(2072L, 1L, "dTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 12), 12, 3L, 3L, "All Specialties"),
  c(2072L, 2L, "dTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 10), 10, 3L, 3L, "All Specialties"),
  c(2072L, 3L, "dTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 5), 5, 3L, 3L, "All Specialties"),
  c(2072L, 5L, "dTR", NA_integer_, "NA", "NA", 4L, total, distribute_hits(total, 0), 0, 3L, 3L, "All Specialties"))
names(decr_data) <- c_names

# Combine all the data together with expected data frame name for analysis
clc_summ <- rbind(ntr_data, rnd_data, incr_data, decr_data)

# Write to input directory
output_path = file.path("input","clc.rdata")
save(clc_summ, file = output_path)
