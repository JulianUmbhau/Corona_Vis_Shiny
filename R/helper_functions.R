
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
  for (i in seq_along(child_nodes)) {
    assign(x = paste(columns[i]),
           value = get_html(webpage, child_nodes[i])
    )
  }
  df_full <- tidyr::tibble(
    country = country,
    population = population,
    pop_per_km2 = pop_per_km2,
    land_area = land_area,
    median_age = median_age,
    urban_pop_pct = urban_pop_pct)

  df_full$population <- as.numeric(gsub(",","",population))
  df_full$pop_per_km2 <- as.numeric(gsub(",","",pop_per_km2))
  df_full$land_area <- as.numeric(gsub(",","",land_area))
  df_full$median_age <- as.numeric(gsub(",","",median_age))
  urban_pop_pct <- gsub("%","",urban_pop_pct)
  df_full$urban_pop_pct <- as.numeric(gsub(",","",urban_pop_pct))

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
  data
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
    tidyr::gather(date,
                  value,
                  -all_of(c(extra_col)))
  long$date <- as.Date(x = long$date,
                       format = "%m-%d-%y")
  long <- aggregate(. ~ date+country+population+pop_per_km2+land_area+median_age+urban_pop_pct,
                    data=long,
                    FUN=sum)
  return(long)
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

  df_full <- obtain_country_data()

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
    dplyr::mutate(value_pr_cap = (value/population)*100000)
  deaths_converted <- deaths_converted %>%
    dplyr::mutate(value_pr_cap = (value/population)*100000)
  data <- list(
    confirmed = confirmed_converted,
    deaths = deaths_converted
  )
  return(data)
}


