library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(DT)
shinyUI(
        fluidPage(
                navbarPage("Where to rent", 
                           #tabPanel("Introduction"),
                           #navbarMenu(title="Begin",
                              tabPanel("Summary",
                                    div(class="outer",
                                        tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                                        leafletOutput("map", width = "100%", height = "100%"),
                                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                                                      top = 110, left = 10, height = "auto",width = 250,
                                                      h3("All about Maps",align="center"),
                                                      hr(),
                                                      h4("Click a Place",align="left"),
                                                      hr(),
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
                                                      ,
                                                      hr(),
                                                      #radioButtons("click_multi", "Show Your Trace", ),
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
                                                selectInput("check_rest1","Resturant Type:", c("Type I care"="",list("American", "Chinese", "Italian", "Japanese", "Pizza", "Others")),multiple=TRUE,selected = list("American", "Chinese", "Italian", "Japanese", "Pizza", "Others")),
                                                selectInput("check_tran1", "Transportation Type:", list("Bus","Subway"),multiple=TRUE,
                                                           selected =  list("Bus","Subway")),
                                                selectInput("check_ct1", "Cinema/Theatre:", list("Cinema","Theatre"),multiple=TRUE,
                                                            selected =  list("Cinema","Theatre")),
                                                selectInput("check_m1", "Market:", list("Pharmacy","Grocery"),multiple=TRUE,
                                                            selected =  list("Pharmacy","Grocery")),
                                                selectInput("check_cr1", "Crime:", list("ROBBERY", "PETIT LARCENY", "HARRASSMENT 2", "GRAND LARCENY", "DANGEROUS DRUGS",
                                                                                         "ASSAULT 3 & RELATED OFFENSES","Others"),multiple=TRUE,
                                                            selected =  list("ROBBERY", "PETIT LARCENY", "HARRASSMENT 2", "GRAND LARCENY", "DANGEROUS DRUGS",
                                                                              "ASSAULT 3 & RELATED OFFENSES","Others")),
                                                checkboxInput("check_cb1", c("Club/Bar"), value = T)
                                                # 
                                                # checkboxInput("check_rest",label="Restaurant", value = T),
                                                # checkboxInput("check_tran",label="Transportation", value = T),
                                                # checkboxInput("check_cb",label="Clubs/Bars", value = T),
                                                # checkboxInput("check_ct",label="Cinema/Theatre", value = T),
                                                # checkboxInput("check_m",label="Market", value = T),
                                                # checkboxInput("check_cr",label="Crime", value = T)
                                                #checkboxInput("clear", label = "CLEAR ALL")
                                            ),
                                            div(id = "action",
                                                actionButton("all_types", "Select ALL"),
                                                actionButton("no_types", "Clear ALL")

                                            )

                                          ),
                                          mainPanel(
                                            leafletOutput("map2", width = "100%", height = "700px")
                                          )
                                        )
                                    )


                           ),
                           
                           tabPanel("Recommendation",fluidPage(
                              fluidRow(
                               column(3,
                                      h6("Choose What You Like"),
                                      div(id = "action",actionButton("no_rec2", "Reset"))),
                               column(3,
                                      sliderInput("check2_pr", "Price Per Room:",min = 850, max = 5400, value = 5400)),
                               column(3,
                                      selectInput("check2_ty", "Apartment Type:",c("Types I Like"="",list("Studio","1B","2B", "3B","4B")), multiple=TRUE)),
                                      column(3,
                                             selectInput("check2_re", "Resturant Type:", c("Food I Like"="",list("American", "Chinese", "Italian", "Japanese", "Pizza", "Others")), multiple=TRUE))),
                                     
                              fluidRow(
                                column(3,
                                       selectInput("check2_tr", "Transportation:", list("Who Cares","Emmm","It's everything"))),
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
                           
                           tabPanel("Contact"
                           
                                    
                                    
                                    )
                           )
                )
        
)