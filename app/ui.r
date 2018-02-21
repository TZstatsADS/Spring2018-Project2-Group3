library(shiny)
library(leaflet)
library(data.table)
library(plotly)
library(DT)
shinyUI(
        fluidPage(includeCSS("style.css"),
                navbarPage(p(class="h","Rent Smart"),id = "inTabset",
                           #tabPanel("Introduction"),
                           #navbarMenu(title="Begin",
                              tabPanel("All about map",
                                    div(class="outer",
                                        tags$style(type = "text/css", ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                                        leafletOutput("map", width = "120%", height = "120%"),
                                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                                                      top = 100, left = 10, height = "auto",width = 243,
                                                      h2("All about Map",align="center"),
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
                  
                                                      checkboxInput("click_multi","Show Your Trace", value = F),
                                                      actionButton("click_reset_buttom","Click here back to original view")
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
                                                actionButton("no_types", "Clear ALL"),
                                                actionButton("click_reset_dot","Click here back to original view")
                                               
                                            )),
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
                                      selectInput("check2_tr", "Transportation:", list("Who Cares.","Emmm.","It's everything.")))),
                                             
                              fluidRow(
                                column(3,
                                       h1("Choose What You Like"),
                                       fluidRow(
                                         column(2,
                                                div(id = "action",actionButton("no_rec2", "Reset"))),
                                         column(1,offset = 2,
                                                div(actionButton("click_jump_next","View Compare"))
                                       ))),
                                column(3,
                                       selectInput("check2_cb", "Club/Bar:", list("I'm allergic.","Drink one or two.","Let's party!"))),
                                column(3,
                                       selectInput("check2_ct", "Cinema/Theater:",list("Netflix for life.","It depends.","Theatre goers."))),
                                column(3,
                                       selectInput("check2_ma","Market:",list("Just Amazon.","It depends.","Love it!")))),
                                   
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
                          

                           tabPanel("Compare",fluidPage(
                             fluidRow(column(6,
                                             p(class = "cr","Crime Dec.2017"),align= "center"
                                             ),
                                      column(6,
                                             p(class = "re","Restaurant"),align= "center")
                                      ),
                             fluidRow(column(6,
                                          plotOutput(outputId = "pic_cr")
                                        ),
                                      column(6,
                                             plotOutput(outputId = "pic_re")
                                             )),
                             
                             
                             fluidRow(column(6,
                                             p(class = "tr","Transportation"),align= "center"
                             ),
                             column(6,
                                    p(class = "ba","Bar"),align= "center")
                             ),
                             fluidRow(
                                      column(6,
                                             plotOutput(outputId = "pic_tr")
                                      ),
                                      column(6,
                                             plotOutput(outputId = "pic_ba")               
                                             )),
                             
                             
                             fluidRow(column(6,
                                             p(class = "ct","Cinema/Theatre"),align= "center"
                             ),
                             column(6,
                                    p(class = "ma","Market"),align= "center")
                             ),
                             fluidRow(column(6,
                                             plotOutput(outputId = "pic_th")
                                      ),
                                      column(6,
                                             plotOutput(outputId = "pic_ma")
                                      ))
                           )
                           ),
                           
                           tabPanel("Contact",fluidPage(
                             sidebarLayout(
                               sidebarPanel(
                                            h2("Contact Information"),
                                            hr(),
                                            h6("We are all Columbia University students at Department of Statistics.
                                               If you are interested in our project, you can contact us."),
                                            hr(),
                                            h6("Wanting Cui : "),
                                            h6("wc2619@columbia.edu"),
                                            h6("Xiuruo  Yan  : "),
                                            h6("xy2358@columbia.edu"),
                                            h6("Hanying Ji  : "),
                                            h6("hj2473@columbia.edu"),
                                            h6("Yu      Tong : "),
                                            h6("yt2594@columbia.edu"),
                                            h6("Xueying Ding: "),
                                            h6("xd2196@columbia.edu")
                               ),
                               mainPanel(
                                 fluidRow(tags$img(height = 120, src = "icon/1.png"),align="center"),
                                 fluidRow(tags$img(height = 120, src = "icon/2.png"),align="center"),
                                 fluidRow(tags$img(height = 120, src = "icon/5.png"),align="center"),
                                 fluidRow(tags$img(height = 120, src = "icon/3.png"),align="center"),
                                 fluidRow(tags$img(height = 120, src = "icon/4.png"),align="center")
                                 )
                           )))
                
                )
        )
)


