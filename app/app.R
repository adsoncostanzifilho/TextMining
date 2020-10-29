library(shiny)
options(shiny.host = "0.0.0.0")
options(shiny.port = 3838)

source('server.R')
source('ui.R')

shinyApp(ui = ui, server = server)