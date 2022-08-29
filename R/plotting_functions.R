
#' @title create_labels
#' @description creates labels for plot legend with coutry names and flags
#'
#' @param country_list list of countries input
#'
#' @import emo
#'
#' @return list of countries and flags appended
#' @export
create_labels <- function(country_list){
  legend_labels <- c()
  for (country in country_list) {
    if("try-error" %in% class(try(emo::ji_find(country), silent = TRUE))) {
      flag <- emo::ji_find("question_mark")
    } else {
      flag <- emo::ji_find(country)
    }
    temp_tt <- paste0(c(country, " ", flag[[2]]), collapse = "")
    legend_labels <- paste0(c(legend_labels, temp_tt))
  }
  return(legend_labels)
}


#' @title renderplot function
#' @description renders graphs
#'
#' @param input input, userbased
#' @param plot_type type of plot, case_number or cases_pr_citizen
#'
#' @import scales
#' @import ggplot2
#' @importFrom plotly ggplotly renderPlotly
#'
#' @return graph
#' @export
renderPlot_function <- function(input, plot_type){
  renderPlotly({
    if(plot_type == "case_number"){
      graph_choice <- input$graph
      country_list <- input$countries
      date_range_start <- input$daterange[1]
      date_range_end <- input$daterange[2]
      data_value <- "value"
      title <- "Cases"
      y_lab <- "Number of Cases"
      create_graph_non_forecast(graph_choice,
                                country_list,
                                date_range_start,
                                date_range_end,
                                data_value,
                                title,
                                y_lab)
    } else if (plot_type == "cases_pr_citizen") {
      graph_choice <- input$graph2
      country_list <- input$countries2
      date_range_start <- input$daterange2[1]
      date_range_end <- input$daterange2[2]
      data_value <- "value_pr_cap"
      title <- "Cases per 100,000 citizens"
      y_lab <- "Number of Cases per 100,000 Citizens"
      create_graph_non_forecast(graph_choice,
                                country_list,
                                date_range_start,
                                date_range_end,
                                data_value,
                                title,
                                y_lab)
    } else if(plot_type == "fatality_rate") {
      graph_choice <- "fatality_rate"
      country_list <- input$countries3
      date_range_start <- input$daterange3[1]
      date_range_end <- input$daterange3[2]
      data_value <- "value_fatality_rate"
      title <- "Fatality Rate"
      y_lab <- "Deaths per Confirmed Case - pct"
      create_graph_non_forecast(graph_choice,
                                country_list,
                                date_range_start,
                                date_range_end,
                                data_value,
                                title,
                                y_lab)
    } else if(plot_type == "daily_cases") {
      graph_choice <- input$graph4
      country_list <- input$countries4
      date_range_start <- input$daterange4[1]
      date_range_end <- input$daterange4[2]
      data_value <- "daily_value"
      title <- "Daily Cases"
      y_lab <- "Number of Daily Cases"
      create_graph_non_forecast(graph_choice,
                                country_list,
                                date_range_start,
                                date_range_end,
                                data_value,
                                title,
                                y_lab)
    } else if (plot_type == "case_number_forecast") {
      graph_choice <- input$graph5
      country_list <- input$countries5
      date_range_start <- input$daterange5[1]
      date_range_end <- input$daterange5[2]
      forecast_horizon <- input$slider1
      models <- input$models
      data_value <- "value"
      title <- "Cases - with forecast"
      y_lab <- "Number of Cases"
      create_graph_forecast(graph_choice,
                            country_list,
                            date_range_start,
                            date_range_end,
                            data_value,
                            models,
                            title,
                            y_lab,
                            forecast_horizon
      )
    } else {
      stop("No plot type chosen")
    }
    
  })
}


#' Title
#'
#' @param graph_choice choice of graph
#' @param country_list countries chosen
#' @param date_range_start date start
#' @param date_range_end date end
#' @param data_value column with data
#' @param title title
#' @param y_lab y axis label
#' @param models models to forecast
#' @param forecast_horizon forecast time in days
#'
#' @return plot of country with forecasts
#' @export
create_graph_forecast <- function(graph_choice,
                                  country_list,
                                  date_range_start,
                                  date_range_end,
                                  data_value,
                                  models,
                                  title,
                                  y_lab,
                                  forecast_horizon) {
  
  if(graph_choice == "Confirmed Cases"){
    temp <- corona_data$confirmed
  } else if(graph_choice == "Confirmed Deaths"){
    temp <- corona_data$deaths
  } else {
    stop("Wrong graph choice")
  }
  
  country_data <- temp %>%
    filter(.data$country %in% country_list) %>%
    select(date, .data$value) %>%
    mutate(date = as.Date(date)) %>%
    as_tibble()
  
  calibration_table <- create_country_models(country_data = country_data,
                                             n = 20)
  
  country_data <- country_data %>%
    filter(date > date_range_start,
           date < date_range_end)
  
  p <- calibration_table %>%
    # Remove RANDOMFOREST model with low accuracy
    # filter(.model_desc %in% models) %>% # Not correct format?
    # Refit and Forecast Forward
    #  modeltime_refit(country_data) %>%
    modeltime_forecast(h = forecast_horizon,
                       actual_data = country_data) %>%
    plot_modeltime_forecast(.interactive = TRUE,
                            .conf_interval_show = FALSE,
                            .title = title,
                            .y_lab = y_lab)
  
  p
}



# graph baseret på predictions af eksisterende modeller
# - confirmed/deaths
# - model
# - country
# create_graph_forecast_pre_model <- function(
#     graph_choice,
#     country_list,
#     date_range) {
#   country_data <- samlet_data[country_list]
#   
#   if(graph_choice == "Confirmed Cases"){
#     temp <- corona_data$confirmed
#   } else if(graph_choice == "Confirmed Deaths"){
#     temp <- corona_data$deaths
#   } else {
#     stop("Wrong graph choice")
#   }
#   
# }




#' Title
#'
#' @param graph_choice choice of graph
#' @param country_list countries chosen
#' @param date_range_start date start
#' @param date_range_end date end
#' @param data_value column with data
#' @param title title
#' @param y_lab y axis label
#'
#' @return graphs without forecasts
#' @export
create_graph_non_forecast <- function(graph_choice,
                                      country_list,
                                      date_range_start,
                                      date_range_end,
                                      data_value,
                                      title,
                                      y_lab) {
  if(graph_choice == "Confirmed Cases"){
    temp <- corona_data$confirmed
  } else if(graph_choice == "Confirmed Deaths"){
    temp <- corona_data$deaths
  } else if(graph_choice == "fatality_rate"){
    temp <- corona_data$collected
  } else {
    stop("Wrong graph choice")
  }
  
  temp <- temp %>%
    filter(.data$country %in% country_list) %>%
    filter(date >= date_range_start,
           date <= date_range_end) %>%
    arrange(.data$country)
  
  country_list <- sort(country_list)
  legend_labels <- create_labels(country_list)
  
  p <- temp %>%
    ggplot(aes_string("date",
                      paste0(data_value),
                      color = "country")) +
    geom_point() +
    xlab("Date Range") +
    ylab(y_lab) +
    ggtitle(title) +
    scale_x_date(breaks = scales::pretty_breaks(n = 10)) +
    scale_y_continuous(labels = scales::comma,
                       breaks = scales::pretty_breaks(n = 10)) +
    labs(color = "Countries") +
    scale_colour_discrete(labels = legend_labels)
  plotly::ggplotly(p)
  
}
