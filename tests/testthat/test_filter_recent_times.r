library(tibble)
library(lubridate)

context('Test Time Filtering')

input_table <- tibble::tribble(
  ~report_month, ~sta6a, ~type,  ~value,
  ymd("2017-03-01"),     "foo",  "short", 10,
  ymd("2017-03-01"),     "foo",  "long",  10,
  ymd("2017-04-01"),     "foo",  "short", 10,
  ymd("2017-04-01"),     "foo",  "long",  10,
  ymd("2018-01-01"),     "foo",  "short", 10,
  ymd("2018-01-01"),     "foo",  "long",  10,
  ymd("2018-02-01"),     "foo",  "short", 10,
  ymd("2018-02-01"),     "foo",  "long",  10,
  ymd("2018-03-01"),     "foo",  "short", 10,
  ymd("2018-03-01"),     "foo",  "long",  10,
  ymd("2018-04-01"),     "foo",  "short", 10,
  ymd("2018-04-01"),     "foo",  "long",  10
)

test_that("Timepoints before most recent x are removed", {
  result <- filter_recent_times(input_table, 4) 
  expect_equal(sum(result$report_month < ymd("2018-01-01")), 0)
})

test_that("All timepoints after most recent x are retained", {
  result <- filter_recent_times(input_table, 4) 
  expect_equal(nrow(result), 8)
})
