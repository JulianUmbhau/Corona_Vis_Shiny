#' @title myapp
#' @description Wrapper for app, setting ui and server up
#'
#' @import emo
#' @import shiny
#'
#' @return shiny app
#' @export
samlet_UI <- function(){

  ui <- fluidPage(
    titlePanel(paste0("Corona Visualization"),
               windowTitle = "CoronaVis Dashboard"),
    "This visualization describes the number of Corona cases, or the number of
    Corona related deaths, for a chosen timeline and in chosen countries.
    Beneath graph 1 is a graph describing the same numbers,
    but in rates of cases per capita million -
    NB: Registry corrections may occur,
    will be indicated as days with falling total number of cases",
    br(),
    paste0(c("- With thanks to P-Lars, The Bear and L man",
             emo::ji("man_dancing_medium_dark_skin_tone")
    ),
    collapse=""),
    #div("this is blue", style = "color: blue;"),
    br(), br(),
    sidebarLayout(
      sidebarPanel = sidebarPanelUI(),
      mainPanel = mainPanelUI())
  )

}





#' @title sidebarpanelUI
#' @description Side panel UI
#'
#' @import shiny
#'
#' @return ui function
#' @export
sidebarPanelUI <- function(){
  sidebarPanel = sidebarPanel(
    h3(strong("Cases Total")),
    dateRangeInput("daterange",
                   "Date Range",
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date),
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date)),
    selectInput(inputId = "countries",
                label = "Countries",
                choices = unique(corona_data$confirmed$country),
                selected = c("Denmark",
                             "Sweden"),
                multiple = TRUE),
    radioButtons("graph",
                 "Graph",
                 choices = c("Confirmed Cases",
                             "Confirmed Deaths")),
    br(), br(), br(),br(),br(),br(),br(),
    h3(strong("Cases per 100,000 citizens")),
    dateRangeInput("daterange2",
                   "Date Range",
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date),
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date)),
    selectInput("countries2",
                "Countries",
                unique(corona_data$confirmed$country),
                selected = c("Denmark",
                             "Sweden"),
                multiple = TRUE),
    radioButtons("graph2",
                 "Graph",
                 choices = c("Confirmed Cases",
                             "Confirmed Deaths")),
    br(), br(), br(),br(),br(),br(),br(),
    h3(strong("Fatality to case rate - pct")),
    dateRangeInput("daterange3",
                   "Date Range",
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date),
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date)),
    selectInput("countries3",
                "Countries",
                unique(corona_data$confirmed$country),
                selected = c("Denmark",
                             "Sweden"),
                multiple = TRUE),
    br(), br(), br(),br(),br(),br(),br(),
    h3(strong("Daily Cases - negative numbers are corrected to 0")),
    dateRangeInput("daterange4",
                   "Date Range",
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date),
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date)),
    selectInput("countries4",
                "Countries",
                unique(corona_data$confirmed$country),
                selected = c("Denmark",
                             "Sweden"),
                multiple = TRUE),
    radioButtons("graph4",
                 "Graph",
                 choices = c("Confirmed Cases",
                             "Confirmed Deaths")),
    br(), br(), br(),br(),br(),br(),br(),
    h3(strong("Cases Total - with forecasts")),
    dateRangeInput("daterange5",
                   "Date Range",
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date),
                   min(corona_data$confirmed$date),
                   max(corona_data$confirmed$date)),
    sliderInput(inputId = "slider1",
                "Forecasting Horizon - days",
                min = 2,
                max = 100,
                value = 5),
    selectInput("countries5",
                "Countries",
                unique(corona_data$confirmed$country),
                selected = c("Denmark"),
                multiple = FALSE),
    selectInput("models1",
                "Models",
                c("ARIMA(0,2,1)(0,0,2)[7]",
                  "PROPHET",
                  "GLMNET",
                  "RANDOMFOREST",
                  "PROPHET W/ XGBOOST ERRORS"),
                c("ARIMA(0,2,1)(0,0,2)[7]",
                  "PROPHET",
                  "GLMNET",
                  "RANDOMFOREST",
                  "PROPHET W/ XGBOOST ERRORS"),
                multiple = T),
    radioButtons("graph5",
                 "Graph",
                 choices = c("Confirmed Cases",
                             "Confirmed Deaths")),
    width = 3
  )
}

#' @title mainpanelUI
#'
#' @import emo
#' @import shiny
#' @importFrom plotly plotlyOutput
#'
#' @return UI panel function
#' @export
mainPanelUI <- function(){
  mainPanel(
    plotly::plotlyOutput("coolplot"),
    br(), br(), br(),
    plotly::plotlyOutput("coolplot2"),
    br(), br(), br(),
    plotly::plotlyOutput("coolplot3"),
    br(), br(), br(),
    plotly::plotlyOutput("coolplot4"),
    br(), br(), br(),
    plotly::plotlyOutput("coolplot5"),
    width = 9)
}
