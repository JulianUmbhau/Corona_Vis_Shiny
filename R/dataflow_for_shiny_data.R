# library(rdrop2)
#
# url_deaths <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
# url_confirmed <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
# data_path <- "./data/"
#
# corona_data <- data_prep_wrapper(url_confirmed,
#                           url_deaths)
#
# usethis::use_data(corona_data,
#                   overwrite = T)
#
#
#
# ### To create remote access through dropbox, use oauth and create token
# csv_path <- paste0(c(data_path,"corona_data.csv"), collapse = "")
# write.csv(corona_data, csv_path)
#
# dropbox_data_path <- "Uni/R/Projekter/Corona_Shiny_Visualization/data"
# drop_upload(csv_path, dropbox_data_path)
#
