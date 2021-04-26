library(ggplot2)
library(dplyr)
library(rvest)
library(emo)


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
    but in rates of cases per capita million",
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
                   "2020-01-22",
                   "2021-04-18",
                   "2020-01-22",
                   "2021-04-18"),
    selectInput("countries",
                "Countries",
                unique(corona_data$confirmed$country),
                selected = c("Denmark",
                             "Sweden"),
                multiple = TRUE),
    radioButtons("graph",
                 "Graph",
                 c("Confirmed Cases",
                   "Confirmed Deaths")),
    br(), br(), br(),br(),br(),br(),
    h3(strong("Cases per 100,000 citizens")),
    dateRangeInput("daterange2",
                   "Date Range",
                   "2020-01-22",
                   "2021-04-18",
                   "2020-01-22",
                   "2021-04-18"),
    selectInput("countries2",
                "Countries",
                unique(corona_data$confirmed$country),
                selected = c("Denmark",
                             "Sweden"),
                multiple = TRUE),
    radioButtons("graph2",
                 "Graph",
                 c("Confirmed Cases",
                   "Confirmed Deaths")),
    h3(strong("Cases as Percentage of Population")),
    dateRangeInput("daterange2",
                   "Date Range",
                   "2020-01-22",
                   "2021-04-18",
                   "2020-01-22",
                   "2021-04-18"),
    selectInput("countries2",
                "Countries",
                unique(corona_data$confirmed$country),
                selected = c("Denmark",
                             "Sweden"),
                multiple = TRUE),
    radioButtons("graph2",
                 "Graph",
                 c("Confirmed Cases",
                   "Confirmed Deaths"))
  )
}

#' @title mainpanelUI
#'
#' @import emo
#' @import shiny
#'
#' @return UI panel function
#' @export
mainPanelUI <- function(){
  mainPanel(
    plotOutput("coolplot"),
    br(),
    plotOutput("coolplot2"),
    br(),
    tableOutput("results"))
}
