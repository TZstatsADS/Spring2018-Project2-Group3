library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(DT)
shinyUI(
        fluidPage(includeCSS("style.css"),
                navbarPage("Where to rent in Manhattan",
                           #tabPanel("Introduction"),
                           #navbarMenu(title="Begin",
                              tabPanel("All about map",
                                    div(class="outer",
                                        tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                                        leafletOutput("map", width = "120%", height = "120%"),
                                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                                                      top = 100, left = 10, height = "auto",width = 242,
                                                      h2("All about Maps",align="center"),
                                                      hr(),
                                                      h3("Click a Place on the Heatmap",align="center"),
                                                      hr(),
                                                          h4(textOutput("zip_text"),align="left"),
                                                          h4(textOutput("avgprice_text"),align="left"),
                                                          h4(textOutput("avgstudio_text"),align="left"),
                                                          h4(textOutput("avg1b_text"),align="left"),
                                                          h4(textOutput("avg2b_text"),align="left"),
                                                          h4(textOutput("avg3b_text"),align="left"),
                                                          h4(textOutput("avg4b_text"),align="left"),
                                                          h4(textOutput("transportation_text"),align="left"),
                                                          h4(textOutput("amenities_text"),align="left"),
                                                          h4(textOutput("crime_text"),align="left")
                                                      ,
                                                      hr(),
                                                      checkboxInput("click_multi", h5("Show Your Trace"), value = F),
                                                      actionButton("click_reset_buttom",label=(h5("Click here back to original view")))

                                        ))
                                    ),
                                    
                           tabPanel("Dot Details",
                                    div(class="outer",
                                        tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                                        sidebarLayout(
                                          sidebarPanel(
                                            div(id="facilities",
                                                selectInput("check_rest1","Restaurant Type:", c("Type I care"="",list("American", "Chinese", "Italian", "Japanese", "Pizza", "Others")),multiple=TRUE,
                                                            selected = list("American", "Chinese", "Italian", "Japanese", "Pizza", "Others")),
                                                selectInput("check_tran1", "Bus/Subway:", list("Bus","Subway"),multiple=TRUE,
                                                           selected =  list("Bus","Subway")),
                                                selectInput("check_ct1", "Cinema/Theatre:", list("Cinema","Theatre"),multiple=TRUE,
                                                            selected =  list("Cinema","Theatre")),
                                                selectInput("check_m1", "Pharmacy/Grocery:", list("Pharmacy","Grocery"),multiple=TRUE,
                                                            selected =  list("Pharmacy","Grocery")),
                                                selectInput("check_cr1", "Crime:", list("ROBBERY", "PETIT LARCENY", "HARRASSMENT 2", "GRAND LARCENY", "DANGEROUS DRUGS",
                                                                                         "ASSAULT 3 & RELATED OFFENSES","Others"),multiple=TRUE,
                                                            selected =  list("ROBBERY", "PETIT LARCENY", "HARRASSMENT 2", "GRAND LARCENY", "DANGEROUS DRUGS",
                                                                              "ASSAULT 3 & RELATED OFFENSES","Others")),
                                                checkboxInput("check_cb1", c("Club/Bar"), value = T)
                                               
                                            ),
                                            div(id = "action",
                                                actionButton("all_types", "Select ALL"),
                                                actionButton("no_types", "Clear ALL")

                                            )
                                            ),
                                          mainPanel(
                                            leafletOutput("map2", width = "120%", height = "700px")
                                          ))
                                    )
                          ),
                           
                           tabPanel("Recommendation",fluidPage(
                              fluidRow(
                               column(3,
                                      sliderInput("check2_pr", "Price Per Room:",min = 850, max = 5400, value = 5400)),
                               column(3,
                                      selectInput("check2_ty", "Apartment Type:",c("Types I Like"="",list("Studio","1B","2B", "3B","4B")), multiple=TRUE)),
                               column(3,
                                      selectInput("check2_re", "Restaurant Type:", c("Food I Like"="",list("American", "Chinese", "Italian", "Japanese", "Pizza", "Others")), multiple=TRUE)),
                               column(3,
                                      selectInput("check2_tr", "Transportation:", list("Who Cares","Emmm","It's everything")))),
                                             
                                     
                              fluidRow(
                                column(3,
                                       h4(strong("Choose What You Like"), color ="#4CB5F5"),
                                       div(id = "action",actionButton("no_rec2", "Reset"))),
                                column(3,
                                       selectInput("check2_cb", "Club/Bar:", list("Who Cares","Emmm","Let's party!"))),
                                column(3,
                                       selectInput("check2_ct", "Cinema/Theater:",list("1","2","3"))),
                                column(3,
                                       selectInput("check2_ma","Market:",list("1","2","3")))),
                                   
                              hr(),
                              
                              fluidRow(
                                column(6,
                                       leafletOutput("map3", width = "auto", height = 490),
                                       fluidRow(column(1,actionButton("click_back_buttom",label="Click here back to original view")))
                                       ),
                                column(6,
                                       dataTableOutput("recom")
                              )))
                              ),
                           
                           tabPanel("Contact",fluidPage(
                             fluidRow(tags$img(height = 120, src = "icon/1.png"),align="center"),
                             fluidRow(tags$img(height = 120,src = "icon/2.png"),align="center"),
                             fluidRow(tags$img(height = 120,src = "icon/5.png"),align="center"),
                             fluidRow(tags$img(height = 120,src = "icon/3.png"),align="center"),
                             fluidRow(tags$img(height = 120,src = "icon/4.png"),align="center"))
                           )
                           
                           )
                )
        
)








