context("test readEEM")

test_that("files read are labelled as EEM class", {
    data <- readEEM(c("rawdata-F7000.txt", "rawdata-FP8500.csv", "rawdata-F7000_Japanese.xls"))
    expect_is(data, "EEM")
})
