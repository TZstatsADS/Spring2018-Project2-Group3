library(ggmap)
library(ggplot2)

load("../output/price.RData")
load("../output/avg_price_zip.RData")
load("../output/subdat.RData")
rank_all <- read.csv("../data/rank_all.csv")


shinyServer(function(input, output,session) {
        ## Panel 1: basic map 
        output$map <- renderLeaflet({
                leaflet()%>%
                        setView(lng = -73.98928, lat = 40.75042, zoom = 13)
        })
        output$map2 <- renderLeaflet({
                leaflet()%>%
                        setView(lng = -73.98928, lat = 40.75042, zoom = 13)%>%
                        addProviderTiles("Stamen.TonerLite")
        })
        
        
        ##########################################################################
        ## Panel 4: recommand map#################################################
        ########################################################################## 
        
        output$map3 <- renderLeaflet({
          leaflet()%>%
            setView(lng = -74.015, lat = 40.75042, zoom = 13)%>%
            addProviderTiles("Stamen.TonerLite")
        })
        
        ## Panel 2: heat map
        # ----- set uo color pallette https://rstudio.github.io/leaflet/colors.html
        # Create a continuous palette function
        pal <- colorNumeric(
                palette = "Reds",
                domain = subdat$value
        )
        leafletProxy("map",data=subdat)%>%
                addPolygons(layerId = ~ZIPCODE,
                            stroke = T, weight=1,
                            fillOpacity = 0.95,
                            color = ~pal(value),
                            highlightOptions = highlightOptions(color='#ff0000', opacity = 0.5, weight = 4, fillOpacity = 0.9,
                                                                bringToFront = TRUE, sendToBack = TRUE))%>%
                addLegend(pal = pal, values = ~value, opacity = 1)
 
  
        ## Panel 3: click on any area, popup text about this zipcode area's information
        observeEvent(input$map_shape_click, {
                click <- input$map_shape_click
                zip_sel<-as.character(revgeocode(as.numeric(c(click$lng,click$lat)),output="more")$postal_code)
                zip<-paste("ZIPCODE: ",zip_sel)
                price_avg<-paste("Average Price: $",avg_price_zip.df[avg_price_zip.df$region==zip_sel,"value"],sep="")
                studio_avg<-paste("Studio: $",price[price$region==zip_sel&price$type=="Studio","avg"],sep="")
                OneB_avg<-paste("1B: $",price[price$region==zip_sel&price$type=="OneBedroom","avg"],sep="")
                TwoB_avg<-paste("2B: $",price[price$region==zip_sel&price$type=="TwoBedroom","avg"],sep="")
                ThreeB_avg<-paste("3B: $",price[price$region==zip_sel&price$type=="ThreeBedroom","avg"],sep="")
                FourB_avg<-paste("4B: $",price[price$region==zip_sel&price$type=="fOURbEDROOM","avg"],sep="")
                transportation_rank<-paste("Transportation Rank: ",rank_all[rank_all$zipcode==zip_sel,"ranking.trans"],sep="")
                amenities_rank<-paste("Amenities Rank: ",rank_all[rank_all$zipcode==zip_sel,"ranking.amenities"],sep="")
                crime_rank<-paste("Crime Rank: ",rank_all[rank_all$zipcode==zip_sel,"ranking.crime"],sep="")

                leafletProxy("map")%>%
                        setView(click$lng,click$lat,zoom=14,options=list(animate=TRUE))
                output$zip_text<-renderText({zip})
                output$avgprice_text<-renderText({price_avg})
                output$avgstudio_text<-renderText({studio_avg})
                output$avg1b_text<-renderText(({OneB_avg}))
                output$avg2b_text<-renderText(({TwoB_avg}))
                output$avg3b_text<-renderText(({ThreeB_avg}))
                output$avg4b_text<-renderText(({FourB_avg}))
                output$transportation_text<-renderText({transportation_rank})
                output$amenities_text<-renderText({amenities_rank})
                output$crime_text<-renderText({crime_rank})
        })

        ## Panel 4: Colorful map or not
        observeEvent(input$click_colorful_map_or_not,{
                if(input$click_colorful_map_or_not){
                        leafletProxy("map")%>%
                                addTiles()
                }
                else{
                        leafletProxy("map")%>%
                                addProviderTiles(providers$Stamen.Toner, options = providerTileOptions(noWrap = TRUE))
                }
        })
        ## Panel 5: Return to big view
        observeEvent(input$click_reset_buttom,{
                if(input$click_reset_buttom){
                        leafletProxy("map")%>%
                                setView(lng = -73.98928, lat = 40.75042, zoom = 13)%>% 
                                clearPopups()
                }
        })
        observeEvent(input$check_rest,{
                if(input$check_rest){
                        insertUI(
                                selector = "#facilities",
                                where = "afterEnd",
                                ui=absolutePanel(id = "rest_ui", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                                        #top = 80, left = 10, height = "auto",width = 250,
                                        checkboxGroupInput("rest_details",label="Details",
                                                           choices=c("Chinese"="c",
                                                                     "Italian"="i",
                                                                     "Dessert"="d",
                                                                     "American"="a",
                                                                     "Korean"="k")
                                                           )
                                )
                        )

                }
                else{
                        removeUI(
                                selector = "#rest_ui"
                        )
                }
        })
        observeEvent(input$check_tran,{
                if(input$check_tran){
                        insertUI(
                                selector = "#facilities",
                                where = "afterEnd",
                                ui=absolutePanel(id = "tran_ui", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                                                 #top = 80, left = 10, height = "auto",width = 250,
                                                 checkboxGroupInput("tran_details",label="Details",
                                                                    choices=c("Subway"="sub",
                                                                              "Bus"="bs")
                                                 )
                                )
                        )
                        
                }
                else{
                        removeUI(
                                selector = "#tran_ui"
                        )
                }
        })

        
        
        
        
        #########recommadation2
        # observe({
        #   cities <- if (is.null(input$states)) character(0) else {
        #     filter(cleantable, State %in% input$states) %>%
        #       `$`('City') %>%
        #       unique() %>%
        #       sort()
        #   }
        #   stillSelected <- isolate(input$cities[input$cities %in% cities])
        #   updateSelectInput(session, "cities", choices = cities,
        #                     selected = stillSelected)
        # })
        # 
        # observe({
        #   zipcodes <- if (is.null(input$states)) character(0) else {
        #     cleantable %>%
        #       filter(State %in% input$states,
        #              is.null(input$cities) | City %in% input$cities) %>%
        #       `$`('Zipcode') %>%
        #       unique() %>%
        #       sort()
        #   }
        #   stillSelected <- isolate(input$zipcodes[input$zipcodes %in% zipcodes])
        #   updateSelectInput(session, "zipcodes", choices = zipcodes,
        #                     selected = stillSelected)
        # })
        # 
        # observe({
        #   if (is.null(input$goto))
        #     return()
        #   isolate({
        #     map <- leafletProxy("map")
        #     map %>% clearPopups()
        #     dist <- 0.5
        #     zip <- input$goto$zip
        #     lat <- input$goto$lat
        #     lng <- input$goto$lng
        #     showZipcodePopup(zip, lat, lng)
        #     map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
        #   })
        # })
        # 
        # output$ziptable <- DT::renderDataTable({
        #   df <- cleantable %>%
        #     filter(
        #       Score >= input$minScore,
        #       Score <= input$maxScore,
        #       is.null(input$states) | State %in% input$states,
        #       is.null(input$cities) | City %in% input$cities,
        #       is.null(input$zipcodes) | Zipcode %in% input$zipcodes
        #     ) %>%
        #     mutate(Action = paste('<a class="go-map" href="" data-lat="', Lat, '" data-long="', Long, '" data-zip="', Zipcode, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
        #   action <- DT::dataTableAjax(session, df)
        #   
        #   DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
        # })
        # 
        # 
        # 
        # 
        
 

})








