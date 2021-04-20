library(shiny)
library(ggplot2)
library(dplyr)
library(rvest)

sidebarPanelUI <- function(){
  sidebarPanel = sidebarPanel(
    h3(strong("Cases Total")),
    dateRangeInput("daterange",
                   "Date Range",
                   "2020-01-22",
                   "2021-04-18",
                   "2020-01-22",
                   "2021-04-18"),
    selectInput("countries",
                "Countries",
                unique(data$confirmed$country),
                selected = c("Denmark",
                             "Sweden"),
                multiple = TRUE),
    radioButtons("graph",
                 "Graph",
                 c("Confirmed Cases",
                   "Confirmed Deaths")),
    br(), # clean up: title, x_axis, y_axis,
    br(), br(),br(),br(),br(),
    h3(strong("Cases per 100,000 citizens")),
    dateRangeInput("daterange2",
                   "Date Range",
                   "2020-01-22",
                   "2021-04-18",
                   "2020-01-22",
                   "2021-04-18"),
    selectInput("countries2",
                "Countries",
                unique(data$confirmed$country),
                selected = c("Denmark",
                             "Sweden"),
                multiple = TRUE),
    radioButtons("graph2",
                 "Graph",
                 c("Confirmed Cases",
                   "Confirmed Deaths"))
  )
}

mainPanelUI <- function(){
  mainPanel(
    plotOutput("coolplot"),
    br(),
    plotOutput("coolplot2"),
    br(),
    tableOutput("results"))
}


myapp <- function(){
  ui <- fluidPage(
    titlePanel("Corona Visualization",
               windowTitle = "CoronaVis Dashboard"),
    "This visualization describes the number of Corona cases, or the number of Corona related deaths, for a chosen timeline and in chosen countries. Beneath graph 1 is a graph describing the same numbers, but in rates of cases per capita million",
    #div("this is blue", style = "color: blue;"),
    br(),
    br(),
    sidebarLayout(
      sidebarPanel = sidebarPanelUI(),
      mainPanel = mainPanelUI())
  )

  server <- function(input, output, session) {
    output$coolplot <- renderPlot_CasesNumber(input)

    output$coolplot2 <- renderPlot_CasesPerCitizen(input)
  }

  shinyApp(ui, server)
}
