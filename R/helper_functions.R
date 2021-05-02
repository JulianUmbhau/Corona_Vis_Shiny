
#' @title get_html
#' @description scrapes nodes from online datatable
#'
#' @param x child node to scrape
#' @param webpage John Hopkins scrape site
#'
#' @importFrom rvest html_text html_nodes
#'
#' @return data from node
#' @export
get_html <- function(webpage, x){
  html_site <- paste0('tr :nth-child(',x,')')
  html_data <- rvest::html_nodes(webpage, html_site)
  data <- rvest::html_text(html_data)
  data <- data[2:236]
  return(data)
}


#' @title obtain_country_data
#' @description obtains country data from worldometers.com
#'
#' @importFrom rvest read_html
#' @import dplyr
#' @import tidyr
#'
#' @return country data
#' @export
obtain_country_data <- function(){
  webpage <- rvest::read_html("https://www.worldometers.info/world-population/population-by-country/")
  child_nodes <- c(2,3,6,7,10,11)
  columns <- c("country",
               "population",
               "pop_per_km2",
               "land_area",
               "median_age",
               "urban_pop_pct")
  df <- list()
  for (i in seq_along(child_nodes)) {
    df[columns[i]] <- list(get_html(webpage, child_nodes[i]))
  }
  df_full <- tidyr::tibble(
    country = df$country,
    population = as.numeric(gsub(",","",df$population)),
    pop_per_km2 = as.numeric(gsub(",","",df$pop_per_km2)),
    land_area = as.numeric(gsub(",","",df$land_area)),
    median_age = as.numeric(gsub(",","",df$median_age)),
    urban_pop_pct = as.numeric(gsub(",","", gsub("%","",df$urban_pop_pct))))
  return(df_full)
}


#' @title data_prep
#' @description prepares country data for use in dataset
#'
#' @param data dataset containing case data
#' @param country_data dataset containing country data
#'
#' @import assertthat
#'
#' @return merged dataset prepared for plotting
#' @export
data_prep <- function(data, country_data){
  if(!assertthat::has_name(x = data,
                           which = c("Country.Region",
                                     "Province.State"))){
    stop("Missing variables")
  }
  stopifnot(assertthat::has_name(x = country_data,
                                 which = "country")
  )
  stopifnot(assertthat::not_empty(data))
  stopifnot(assertthat::not_empty(country_data))

  navne <- names(data)
  navne <- sub("X","",navne)
  navne <- gsub("\\.","-",navne)
  navne <- sub("Province-State","province",navne)
  navne <- sub("Country-Region","country",navne)
  names(data) <- navne
  data$country <- gsub("US", "United States", data$country)
  data$country <- gsub("Korea, South", "South Korea", data$country)
  data$country <- as.character(data$country)
  data <- merge(data, country_data, by = "country")
  return(data)
}


#' @title convert_to_long
#' @description converts dataset with dates to long, removes
#'
#' @param data dataset with cases and country data
#' @param extra_col columns for country data
#'
#' @importFrom tidyr gather
#' @importFrom stats aggregate
#' @import dplyr
#'
#' @return dataset converted to long
#' @export
convert_to_long <- function(data, extra_col){
  long <- data %>%
    dplyr::select(-all_of(c("Long",
                            "Lat",
                            "province"))
    ) %>%
    tidyr::gather(key = "date",
                  value = "value",
                  -all_of(c(extra_col))) %>%
    mutate(date = as.Date(x = date, format = "%m-%d-%y"))
  long <- aggregate(. ~ date+country+population+pop_per_km2+land_area+median_age+urban_pop_pct,
                    data=long,
                    FUN=sum)
  return(long)
}


#' @title create_daily_cases
#' @description creates columns with daily case numbers
#'
#' @param data dataframe with converted data
#'
#' @return
#' @export
create_daily_cases <- function(data) {
  confirmed_converted_delta <- data.frame()
  for (country_i in unique(data$country)) {
    temp <- data %>%
      filter(country == country_i)
    for (i in 1:nrow(temp)) {
      temp$daily_value[i] <- temp$value[i]-temp$value[i-1]
      temp$daily_value[temp$daily_value %>% is.null()] <- 0
    }
    confirmed_converted_delta <- bind_rows(confirmed_converted_delta, temp)
  }
  confirmed_converted_delta[confirmed_converted_delta$daily_value < 0] <- 0
  confirmed_converted_delta
}


#' @title data_prep_wrapper
#' @description wrapper function for data prep
#'
#' @param url_confirmed url to confirmed cases
#' @param url_deaths url to death cases
#'
#' @importFrom dplyr mutate
#' @importFrom utils read.csv
#'
#' @return dataset containing cases and country data
#' @export
data_prep_wrapper <- function(url_confirmed, url_deaths){

  confirmed_cases <- read.csv(url_confirmed)

  deaths <- read.csv(url_deaths)

  df_full <- suppressWarnings(obtain_country_data())

  confirmed_cases <- data_prep(data = confirmed_cases,
                               country_data = df_full)

  deaths <- data_prep(data = deaths,
                      country_data = df_full)

  extra_col <- c("country",
                 "population",
                 "pop_per_km2",
                 "land_area",
                 "median_age",
                 "urban_pop_pct")

  confirmed_converted <- convert_to_long(data = confirmed_cases,
                                         extra_col = extra_col)
  deaths_converted <- convert_to_long(data = deaths,
                                      extra_col = extra_col)

  confirmed_converted <- confirmed_converted %>%
    mutate(value_pr_cap = (.data$value/.data$population)*100000)
  deaths_converted <- deaths_converted %>%
    mutate(value_pr_cap = (.data$value/.data$population)*100000)

  variables_kept <- c("date",
                      "country",
                      "value")

  collected <- left_join(confirmed_converted,
                         deaths_converted %>%
                           select(all_of(variables_kept)) %>%
                           rename(value_deaths = .data$value)
                         ) %>%
    mutate(value_fatality_rate = (.data$value_deaths/.data$value)*100)
  collected$value_fatality_rate[is.nan(collected$value_fatality_rate)] <- NA

  confirmed_converted <- create_daily_cases(data = confirmed_converted)
  deaths_converted <- create_daily_cases(data = deaths_converted)

  data <- list(
    confirmed = confirmed_converted,
    deaths = deaths_converted,
    collected = collected
  )
  return(data)
}



# library(tidymodels)
# library(vip)
# library(modeltime)
# library(timetk)
# predict_cases <- function(data, ){
#   splits_DK <- confirmed_converted %>%
#     filter(country %in% "Denmark") %>%
#
#
#
#
#
# }

# tt <- create_daily_cases(data = confirmed_converted_orig)
#
#
# confirmed_converted_delta %>%
#   filter(country == "Denmark") %>%
#   ggplot(aes(date, daily_value, color = country)) +
#   geom_point()
#
