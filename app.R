library(shiny)

pkgload::load_all()


# første corona relaterede dødsfald
# - switch imellem cases/deaths
load(file = "data/data.rda")


shinyApp(ui = samlet_UI, server = server)
