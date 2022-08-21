library(CoronaVisualisation)

url_deaths <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
url_confirmed <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
data_path <- paste0(getwd(), "/data/")

corona_data <- data_prep_wrapper(
  url_confirmed,
  url_deaths)

usethis::use_data(corona_data,
                  overwrite = T)
#
#
### creating starting models for every country - NB TAKES LONG!
# - arima, prophet, glmnet, prohpet_boost, randomforest
samlet_data <- list()
i <- 1
load("./data/corona_data.rda")
start_time <- Sys.time()
for (country_ in unique(corona_data$collected$country)[10]) {
  message(country_," ", i)
  i <- i+1
  country_data <- corona_data$confirmed %>%
    filter(country %in% country_)
#  country_models <- create_country_models(country_data)
  country_models <- train_models(country_data)
  samlet_data[country_] <- list(country_models)
}
end_time <- Sys.time()
print(end_time-start_time)

# usethis::use_data(samlet_data,
#                   overwrite = T) # OBS: gives long package load time

train_models <- function(country_data) {
  data_filtered <- country_data %>%
    mutate(date = as.Date(date)) %>%
    select(date, .data$value) %>%
    as_tibble()

  training_days <- 40
  testing_days <- 20

  splits <- data_filtered %>%
    time_series_split(
      initial = paste0(training_days," days"),
      assess = paste0(testing_days," days"),
      cumulative = TRUE,
      slice = 1)

  model_fit_arima <- arima_reg() %>%
    set_engine("auto_arima") %>%
    fit(value ~ date, training(splits))

  model_fit_prophet <- prophet_reg() %>%
    set_engine("prophet", yearly.seasonality = TRUE) %>%
    fit(value ~ date, training(splits))

  recipe_spec <- recipe(value ~ date,
                        training(splits)) %>%
    step_timeseries_signature(date) %>%
    step_rm(contains("am.pm"),
            contains("hour"),
            contains("minute"),
            contains("second"),
            contains("xts")) %>%
    step_fourier(date, period = 365, K = 5) %>%
    step_dummy(all_nominal())

  model_spec_glmnet <- linear_reg(
    penalty = 0.01,
    mixture = 0.5) %>%
    set_engine("glmnet")

  workflow_fit_glmnet <- workflow() %>%
    add_model(model_spec_glmnet) %>%
    add_recipe(recipe_spec %>% step_rm(date)) %>%
    fit(training(splits))

  # Random forest
  model_spec_rf <- rand_forest(trees = 500, min_n = 50) %>%
    set_engine("randomForest")

  workflow_fit_rf <- workflow() %>%
    add_model(model_spec_rf) %>%
    add_recipe(recipe_spec %>% step_rm(date)) %>%
    fit(training(splits))

  # prophet boost
  model_spec_prophet_boost <- prophet_boost() %>%
    set_engine("prophet_xgboost", yearly.seasonality = TRUE)

  workflow_fit_prophet_boost <- workflow() %>%
    add_model(model_spec_prophet_boost) %>%
    add_recipe(recipe_spec) %>%
    fit(training(splits))

  ## eval
  model_table <- modeltime_table(
    model_fit_arima,
    model_fit_prophet,
    workflow_fit_glmnet,
    workflow_fit_rf,
    workflow_fit_prophet_boost
  )

  model_table
}
