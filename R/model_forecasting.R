#' Title
#'
#' @param country_data data with countries to forecast on
#' @param n forecast horizon
#'
#' @import dplyr tidymodels timetk modeltime
#' @importFrom parsnip set_engine fit linear_reg rand_forest fit
#' @importFrom rsample training
#' @importFrom recipes recipe step_rm step_dummy all_nominal
#' @importFrom workflows workflow add_model add_recipe
#'
#' @return modeltable with models trained on country data
#' @export
create_country_models <- function(country_data, n) {
  data_filtered <- country_data %>%
    mutate(date = as.Date(date)) %>%
    select(date, .data$value) %>%
    as_tibble()
  
  splits <- data_filtered %>%
    time_series_split(assess = paste0(n," days"), cumulative = TRUE)
  
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
  
  model_spec_glmnet <- linear_reg(penalty = 0.01,
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





#####################
#' @title forecasting function TBD
#'
#' @param data forecasting data
#' @param country countries to forecast on
#' @param models models to use
#' @param forecast_horizon forecast horizon
#' @param date_range_start datestart
#' @param date_range_end dateend
#' @param calibration_table list with all countries modelled
#'
#' @return forecast plot on premodelled data
#' @export
forecast_on_country_premodelled <- function(data,
                                            country,
                                            date_range_start,
                                            date_range_end,
                                            models,
                                            forecast_horizon,
                                            calibration_table) {
  stopifnot(c("RF", "GLMNet") %in% models)
  
  country_data <- corona_data$confirmed %>%
    filter(country %in% country) %>%
    select(date, .data$value) %>%
    mutate(date = as.Date(date)) %>%
    as_tibble()
  
  
  calibration_table %>%
    # Remove RANDOMFOREST model with low accuracy
    filter(.data$.model_id != 2) %>%
    # Refit and Forecast Forward
    #  modeltime_refit(country_data) %>%
    modeltime_forecast(h = forecast_horizon,
                       actual_data = country_data) %>%
    plot_modeltime_forecast(.interactive = TRUE,
                            .conf_interval_show = FALSE,
                            .title = "Compare all models forecast Plot",
                            .y_lab = "New daily cases")
}




#################################################
#Inspiration - https://rpubs.com/aborderon/covid-19-models-forecasting

#
# # get data
# data_daily  <- read.csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")
# data_daily <- data_daily %>%
#   select(date, new_cases) %>%
#   drop_na(new_cases)
# # aggregate to global data
# time_series_covid19_confirmed_global <- aggregate(data_daily$new_cases,
#                                                   by=list(date=data_daily$date),
#                                                   FUN=sum)
# # data manipulation
# covid19_confirmed_global_tbl <- time_series_covid19_confirmed_global %>%
#   select(date, x) %>%
#   rename(value=x)
#
# covid19_confirmed_global_tbl$date <- as.Date(covid19_confirmed_global_tbl$date, format = "%Y-%m-%d")
# covid19_confirmed_global_tbl <- covid19_confirmed_global_tbl[covid19_confirmed_global_tbl[["date"]] >= "2020-01-17", ]
# covid19_confirmed_global_tbl <- as_tibble(covid19_confirmed_global_tbl)
#
#
# # plot data
# covid19_confirmed_global_tbl %>%
#   plot_time_series(date, value, .interactive = FALSE)
#
# ### splitting data!
# splits <- covid19_confirmed_global_tbl %>%
#   time_series_split(assess = "5 days", cumulative = TRUE)
#
#
# splits %>%
#   tk_time_series_cv_plan() %>%
#   plot_time_series_cv_plan(date, value, .interactive = FALSE)
#
# # models
# model_fit_arima <- arima_reg() %>%
#   set_engine("auto_arima") %>%
#   fit(value ~ date, training(splits))
# model_fit_arima
#
#
#
# model_fit_prophet <- prophet_reg() %>%
#   set_engine("prophet", yearly.seasonality = TRUE) %>%
#   fit(value ~ date, training(splits))
# model_fit_prophet
#
#
# ### tidymodels
# recipe_spec <- recipe(value ~ date,
#                       training(splits)) %>%
#   step_timeseries_signature(date) %>%
#   step_rm(contains("am.pm"),
#           contains("hour"),
#           contains("minute"),
#           contains("second"),
#           contains("xts")) %>%
#   step_fourier(date, period = 365, K = 5) %>%
#   step_dummy(all_nominal())
#
# recipe_spec %>% prep() %>% juice()
#
#
#
# ### arima with recipe data
#
#
# ### glmnet engine
# model_spec_glmnet <- linear_reg(penalty = 0.01,
#                                 mixture = 0.5) %>%
#   set_engine("glmnet")
#
# workflow_fit_glmnet <- workflow() %>%
#   add_model(model_spec_glmnet) %>%
#   add_recipe(recipe_spec %>% step_rm(date)) %>%
#   fit(training(splits))
#
#
# # Random forest
# model_spec_rf <- rand_forest(trees = 500, min_n = 50) %>%
#   set_engine("randomForest")
#
# workflow_fit_rf <- workflow() %>%
#   add_model(model_spec_rf) %>%
#   add_recipe(recipe_spec %>% step_rm(date)) %>%
#   fit(training(splits))
#
#
# # prophet boost
# model_spec_prophet_boost <- prophet_boost() %>%
#   set_engine("prophet_xgboost", yearly.seasonality = TRUE)
#
# workflow_fit_prophet_boost <- workflow() %>%
#   add_model(model_spec_prophet_boost) %>%
#   add_recipe(recipe_spec) %>%
#   fit(training(splits))
#
# ## eval
# model_table <- modeltime_table(
#   model_fit_arima,
#   model_fit_prophet,
#   workflow_fit_glmnet,
#   workflow_fit_rf,
#   workflow_fit_prophet_boost
# )
#
# model_table
#
#
# # calibration
# calibration_table <- model_table %>%
#   modeltime_calibrate(testing(splits))
#
# calibration_table
#
# # forecasting analysis
# calibration_table %>%
#   modeltime_forecast(actual_data = covid19_confirmed_global_tbl) %>%
#   plot_modeltime_forecast(.interactive = T)
#
# calibration_table %>%
#   modeltime_accuracy() %>%
#   table_modeltime_accuracy(.interactive = T)
# ####
#
# # working with models
# # taking out a model
# calibration_table %>%
#   # Remove RANDOMFOREST model with low accuracy
#   filter(.model_id != 2) %>%
#   # Refit and Forecast Forward
#   modeltime_refit(covid19_confirmed_global_tbl) %>%
#   modeltime_forecast(h = "3 months",
#                      actual_data = covid19_confirmed_global_tbl) %>%
#   plot_modeltime_forecast(.interactive = T,
#                           .title = "Compare all models forecast Plot",
#                           .y_lab = "New daily cases")
#
#
#

