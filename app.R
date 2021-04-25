library(shiny)

pkgload::load_all()
shinyApp(ui = samlet_UI, server = server)
