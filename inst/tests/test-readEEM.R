context("test readEEM")

test_that("files read are labelled as EEM class", {
    data <- readEEM(c("rawdata_F-7000.txt", "rawdata_FP-8500.csv", 
                      "rawdata_F-7000_Japanese.xls", "rawdata_RF-6000.txt"))
    expect_is(data, "EEM")
})
