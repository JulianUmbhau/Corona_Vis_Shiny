#' @title server function
#'
#' @param input inputs for server
#' @param output output to server UI
#' @param session session data
#'
#' @return server output
#' @export
server <- function(input, output, session) {
  output$coolplot <- renderPlot_function(input, plot_type = "case_number")
  output$coolplot2 <- renderPlot_function(input, plot_type = "cases_pr_citizen")
}
