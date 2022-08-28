pkgload::load_all()
#library(CoronaVisualisation)

url_deaths <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
url_confirmed <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
data_path <- paste0(getwd(), "/data/")

print("Preparing data")
start_time <- Sys.time()
corona_data <- data_prep_wrapper(
  url_confirmed,
  url_deaths)
function_time <- Sys.time()-start_time
print(paste0("Data prep time: ", function_time))

usethis::use_data(corona_data,
                  overwrite = T)
#
#
### creating starting models for every country - NB TAKES LONG!
# - arima, prophet, glmnet, prohpet_boost, randomforest

print("Modelling data")
samlet_data <- list()
i <- 1
load("./data/corona_data.rda")
start_time <- Sys.time()
for (country_ in unique(corona_data$collected$country)) {
  message(country_," ", i)
  i <- i+1
  country_data <- corona_data$confirmed
  country_data <- country_data %>% 
    dplyr::filter(country == country_)
#  country_models <- create_country_models(country_data)
  country_models <- train_models(country_data)
  confirmed <- list(
    confirmed_data = country_models,
    confirmed_models = country_data
  )
  confirmed <- list(
    confirmed_data = country_models,
    confirmed_models = country_data
  )
  
  deaths <- list()
  samlet_data[[country_]] <- list(models = country_models,
                                data = country_data)
}
function_time <- Sys.time()-start_time
print(paste0("Data prep time: ", function_time))

print("saving data")
start_time <- Sys.time()
usethis::use_data(samlet_data,
                  overwrite = T) # OBS: gives long package load time
function_time <- Sys.time()-start_time
print(paste0("Data prep time: ", function_time))

