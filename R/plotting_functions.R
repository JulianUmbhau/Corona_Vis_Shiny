
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
    } else if (plot_type == "cases_pr_citizen") {
      graph_choice <- input$graph2
      country_list <- input$countries2
      date_range_start <- input$daterange2[1]
      date_range_end <- input$daterange2[2]
      data_value <- "value_pr_cap"
      title <- "Cases per 100,000 citizens"
      y_lab <- "Number of Cases per 100,000 Citizens"
    } else if(plot_type == "fatality_rate") {
      graph_choice <- "fatality_rate"
      country_list <- input$countries3
      date_range_start <- input$daterange3[1]
      date_range_end <- input$daterange3[2]
      data_value <- "value_fatality_rate"
      title <- "Fatality Rate"
      y_lab <- "Deaths per Confirmed Case - pct"
    } else {
      stop("No plot type chosen")
    }

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

  })
}
