library(tibble)

context('Test Input Header Check')

input_table <- tibble::tribble(
  ~foo, ~bar, ~baz, ~baq,
  1,    2,    3,    4, 
  1,    2,    3,    4, 
  1,    2,    3,    4, 
  1,    2,    3,    4 
)

test_that("Table with expected columns checks out.", {
  expected_cols <- c('foo','bar','baz','baq')
  capture.output(
    expect_true(check_input(input_table, expected_cols))
  )
})

test_that("Table with unexpected column name does not check out.", {
  expected_cols <- c('foo','bar','baz','zap')
  capture.output(
    expect_false(check_input(input_table, expected_cols))
  )
})

test_that("Table with too few columns does not check out.", {
  expected_cols <- c('foo','bar','baz','baq', 'extra')
  capture.output(
    expect_false(check_input(input_table, expected_cols))
  )
})

test_that("Table with too many columns does not check out.", {
  expected_cols <- c('foo','bar','baz')
  capture.output(
    expect_false(check_input(input_table, expected_cols))
  )
})