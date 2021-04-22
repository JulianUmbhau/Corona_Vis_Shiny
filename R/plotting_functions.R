#' @title renderplot function
#' @description renders graphs
#'
#' @param input input, userbased
#' @param plot_type type of plot, case_number or cases_pr_citizen
#'
#' @import scales
#' @import ggplot2
#'
#' @return graph
#' @export
renderPlot_function <- function(input, plot_type){
  renderPlot({

    if(plot_type == "case_number"){
      graph_choice <- input$graph
      country_list <- input$countries
      date_range_start <- input$daterange[1]
      date_range_end <- input$daterange[2]
      title <- "Cases"
      y_lab <- "Number of Cases"
    } else {
      graph_choice <- input$graph2
      country_list <- input$countries2
      date_range_start <- input$daterange2[1]
      date_range_end <- input$daterange2[2]
      title <- "Cases per 100,000 citizens"
      y_lab <- "Number of Cases per 100,000 Citizens"
    }

    if(graph_choice == "Confirmed Cases"){
      temp <- data$confirmed
    } else {
      temp <- data$deaths
    }

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

    temp %>%
      filter(country %in% country_list) %>%
      filter(date >= date_range_start,
             date <= date_range_end) %>%
      ggplot(aes(date, value_pr_cap, color = country)) +
      geom_point() +
      xlab("Date Range") +
      ylab(y_lab) +
      ggtitle(title) +
      scale_x_date(breaks = scales::pretty_breaks(n = 10)) +
      scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
      labs(color = "Countries") +
      scale_colour_discrete(labels = legend_labels)

  })
}
