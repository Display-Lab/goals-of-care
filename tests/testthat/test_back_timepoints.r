context('Backward Timepoint Calculation')

test_that("Returns data frame", {
  result <- back_timepoints(fy=2018, quart=3, num=8) 
  expect_s3_class(result, "data.frame")
})

test_that("Returns two columns named 'fy' and 'quart'", {
  result <- back_timepoints(fy=2018, quart=3, num=8) 
  expect_equal(colnames(result), c('fy','quart'))
})

test_that("Counts back given number of time points", {
  result <- back_timepoints(fy=2018, quart=3, num=11) 
  expect_equal(nrow(result), 11)
})

test_that("Max timepoint matches given year and quarter", {
  result <- back_timepoints(fy=2020, quart=3, num=11) 
  max_fy <- max(result$fy)
  max_q_in_fy <- max(result[result$fy==max_fy, 'quart'])
  
  expect_equal(max_fy, 2020)
  expect_equal(max_q_in_fy, 3)
})