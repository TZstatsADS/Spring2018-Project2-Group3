library(shiny)
library(leaflet)
library(data.table)
library(plotly)
shinyUI(
        fluidPage(
                navbarPage("Where to rent", theme = "black.css",
                           #tabPanel("Introduction"),
                           navbarMenu(title="Begin",
                                      tabPanel("Summary",
                                    div(class="outer",
                                        tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                                        leafletOutput("map", width = "100%", height = "100%"),
                                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                                                      top = 110, left = 10, height = "auto",width = 250,
                                                      h3("All about Maps",align="center"),
                                                      checkboxInput("click_colorful_map_or_not", "Detail Map",value=FALSE),
                                                      hr(),
                                                      div(style="text-align:left;
                                                          box-shadow: 10px 30px 30px  #888888;
                                                          width:200px;
                                                          height:230px;
                                                          position:relative;
                                                          font-style: italic",
                                                          h6(textOutput("zip_text"),align="left"),
                                                          h6(textOutput("avgprice_text"),align="left"),
                                                          h6(textOutput("avgstudio_text"),align="left"),
                                                          h6(textOutput("avg1b_text"),align="left"),
                                                          h6(textOutput("avg2b_text"),align="left"),
                                                          h6(textOutput("avg3b_text"),align="left"),
                                                          h6(textOutput("avg4b_text"),align="left"),
                                                          h6(textOutput("transportation_text"),align="left"),
                                                          h6(textOutput("amenities_text"),align="left"),
                                                          h6(textOutput("crime_text"),align="left")
                                                      ),
                                                      hr(),
                                                      actionButton("click_reset_buttom",label="Click here back to original view")

                                        )
                                    )
                                    ),
                                    
                           tabPanel("Dot Details",
                                    div(class="outer",
                                        tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                                        sidebarLayout(
                                                sidebarPanel(
                                                        div(id="facilities",
                                                            checkboxInput("check_rest",label="Restaurant"),
                                                            checkboxInput("check_tran",label="Transportation"),
                                                            checkboxInput("check_cb",label="CLubs/Bars"),
                                                            checkboxInput("check_ct",label="Cinema/Threate"),
                                                            checkboxInput("check_m",label="Market")
                                                            )
                                                ),
                                                mainPanel(
                                                        leafletOutput("map2", width = "100%", height = "700px")
                                                        )
                                                )
                                        )
                                        ),
                           
                           tabPanel("Recommendation",
                                    div(class="outer",
                                        tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                                        leafletOutput("map3", width = "100%", height = "100%"),
                                        absolutePanel(id = "controls", class = "panel panel-default",
                                                      fixed = TRUE, draggable = FALSE,
                                                      top = 110, right = 10, height = "auto",width = 200,
                                                      h4("Choose What"),
                                                      h4(" You Want"),
                                                      hr(),
                                                      div(checkboxGroupInput("check_rest",label="Restaurant"),
                                                          checkboxInput("check_tran",label="Transportation"),
                                                          checkboxInput("check_cb",label="CLubs/Bars"),
                                                          checkboxInput("check_ct",label="Cinema/Threate"),
                                                          checkboxInput("check_m",label="Market")
                                                      )
                                                      
                                        )
                                    )
                           )
                           )
                )
                )
        )
