library(shiny)

pkgload::load_all()

# første corona relaterede dødsfald
# - switch imellem cases/deaths

shinyApp(ui = samlet_UI, server = server)
