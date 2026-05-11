library(shiny)
library(ggplot2)
library(dplyr)
library(sf)

ni <- read_sf("geography-sdz2021-esri-shapefile/SDZ2021.shp")

ui <- fluidPage(
  title = "Northern Ireland Super Data Zones",
  selectInput(
    inputId = "lgd",
    label   = "Select Local Government District:",
    choices = unique(ni$LGD2014_nm),
    selected = unique(ni$LGD2014_nm)[1]
  ),
  fluidRow(
    column(width = 6, plotOutput("map_plot")),
    column(width = 6, plotOutput("point_plot"))
  )
)

server <- function(input, output, session) {
  output$map_plot <- renderPlot({
    ni_selected <- ni |> filter(LGD2014_nm == input$lgd)
    ggplot() +
      geom_sf(data = ni) +
      geom_sf(aes(fill = Perim_km), data = ni_selected) +
      labs(fill = "Perimeter (km)")
  })
  output$point_plot <- renderPlot({
    ni_selected <- ni |> filter(LGD2014_nm == input$lgd)
    ggplot(ni_selected) +
      geom_point(aes(x = Perim_km, y = Area_ha)) +
      labs(x = "Perimeter (km)", y = "Area (hectare)")
  })
}

shinyApp(ui = ui, server = server)