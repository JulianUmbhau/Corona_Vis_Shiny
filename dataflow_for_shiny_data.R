source("./R/helper_functions.R")
url_deaths <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
url_confirmed <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
data_path <- "./data/"

data <- data_prep_wrapper(url_confirmed,
                          url_deaths)

saveRDS(data,
        paste0(data_path,
               "/data.rds"))

