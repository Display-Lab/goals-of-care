library(tibble)

context('Test Time Filtering')

input_table <- tibble::tribble(
  ~fy, ~quart, ~sta6a, ~type,  ~value,
  2018, 1,     "foo",  "short", 10,
  2018, 1,     "foo",  "long",  10,
  2018, 2,     "foo",  "short", 10,
  2018, 2,     "foo",  "long",  10,
  2018, 3,     "foo",  "short", 10,
  2018, 3,     "foo",  "long",  10,
  2018, 4,     "foo",  "short", 10,
  2018, 4,     "foo",  "long",  10,
  2017, 3,     "foo",  "short", 10,
  2017, 3,     "foo",  "long",  10,
  2017, 4,     "foo",  "short", 10,
  2017, 4,     "foo",  "long",  10
)

test_that("Timepoints before most recent x are removed", {
  result <- filter_recent_times(input_table, 4) 
  expect_equal(sum(result$fy == 2017), 0)
})

test_that("All timepoints after most recent x are retained", {
  result <- filter_recent_times(input_table, 4) 
  expect_equal(nrow(result), 8)
})
