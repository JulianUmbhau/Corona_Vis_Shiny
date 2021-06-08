library(CoronaVisualisation)

url_deaths <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
url_confirmed <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
data_path <- "./data/"

corona_data <- data_prep_wrapper(url_confirmed,
                          url_deaths)

usethis::use_data(corona_data,
                  overwrite = T)
#
#
### creating starting models for every country - NB TAKES LONG!
# - arima, prophet, glmnet, prohpet_boost, randomforest
# samlet_data <- list()
# i <- 1
# load("./data/corona_data)
# for (country_ in unique(data$country)) {
#   message(country_, i)
#   i <- i+1
#   country_data <- data %>%
#     filter(country %in% country_)
#   country_models <- create_country_models(country_data)
#   samlet_data[country_] <- list(country_models)
# }
# usethis::use_data(samlet_data,
#                   overwrite = T) # OBS: gives long package load time
