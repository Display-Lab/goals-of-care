context('Test Reading Config')

test_that("Missing config generates warning.", {
  expect_warning(read_config('nonextant.yml'), "Config file not found:")
})

test_that("Default config used for all when bad config is supplied", {
  result <- expect_warning(read_config('nonextant.yml'))
  expect_identical(result[['clc']], GOCC$DEFAULT_CFG)
  expect_identical(result[['hbpc']], GOCC$DEFAULT_CFG)
  expect_identical(result[['dementia']], GOCC$DEFAULT_CFG)
})