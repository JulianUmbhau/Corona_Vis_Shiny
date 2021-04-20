test_data <- data.frame(c("",""),
                        c("US",
                          "Korea, South")
)
test_country_data <- data.frame(country = c("United States",
                                            "South Korea"),
                                test_col = c(1,2)
                                )
colnames(test_data) <- c("Province-State",
                         "Country-Region")
args <- list(test_data,
             test_country_data)
result <- do.call(data_prep, args)

test_that(
  "Testing data_prep correct outcome", {
    expect_equal(object = names(result),
                 expected = c("country", "province", "test_col"))
    expect_equal(result[["test_col"]],
                 expected = c(2,1))
  }
)

test_that(
  "Testing correct error by wrong data", {
    test_country_data_empty <- c()
    expect_error(data_prep(data = test_data,
                           country_data = test_country_data_empty))

    test_country_data_empty <- data.frame("country")
    expect_error(data_prep(test_data,
                           test_country_data_empty))

  }
)


