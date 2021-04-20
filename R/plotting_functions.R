renderPlot_CasesNumber <- function(input){
  renderPlot({
    ifelse(input$graph[1] == "Confirmed Cases",
           temp <- data$confirmed,
           temp <- data$deaths)
    temp %>%
      filter(country %in% input$countries) %>%
      filter(date >= input$daterange[1],
             date <= input$daterange[2]) %>%
      ggplot(aes(date, value, color = country)) +
      geom_point() +
      xlab("Date Range") +
      ylab("Number of Cases") +
      ggtitle("Cases")
  })
}




renderPlot_CasesPerCitizen <- function(input){
  renderPlot({
    ifelse(input$graph2[1] == "Confirmed Cases",
           temp <- data$confirmed,
           temp <- data$deaths)
    temp %>%
      filter(country %in% input$countries2) %>%
      filter(date >= input$daterange2[1],
             date <= input$daterange2[2]) %>%
      ggplot(aes(date, value_pr_cap, color = country)) +
      geom_point() +
      xlab("Date Range") +
      ylab("Number of Cases") +
      ggtitle("Cases per 100,000 citizens")
  })
}


