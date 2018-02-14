library(shiny)
library(leaflet)
library(data.table)
library(plotly)
shinyUI(
        fluidPage(
                
                tabPanel("Map",
                         div(class="outer",
                             leafletOutput("map", width = "100%", height = "770px"),
                             absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                           top = 120, left = 20, right = "auto", bottom = "auto", width = 250, height = "auto",
                                           h3("All about Maps"),
                                           checkboxInput("click_colorful_map_or_not", "Detail Map",value=FALSE)
                                           
                             )
                         )
                )
        )
)