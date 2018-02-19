library(ggmap)
library(ggplot2)

load("../output/price.RData")
load("../output/avg_price_zip.RData")
load("../output/subdat.RData")
restaurant <- read.csv("../data/res.fil1.csv",as.is = T)
crime <- read.csv("../data/crime_data.csv",as.is = T)
market <- read.csv("../data/market_dxy.csv",as.is = T)
art <- read.csv("../data/theatre_dxy.csv",as.is = T)
rank_all <- read.csv("../data/rank_all.csv",as.is = T)


shinyServer(function(input, output,session) {
        ## Panel 1: basic map 
        output$map <- renderLeaflet({
                leaflet()%>%
                        setView(lng = -73.98928, lat = 40.75042, zoom = 13)
        })
        
        
        
        
        #################################################################
        ##### Panel 2 :dot.detail########################################
        #################################################################
        output$map2 <- renderLeaflet({
          m <- leaflet()%>%
            setView(lng = -73.98928, lat = 40.75042, zoom = 13)%>%
            addProviderTiles("Stamen.TonerLite")
          leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'Chinese'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#D24136", popup = ~DBA, stroke = FALSE, fillOpacity = 0.5,radius = 5, group  = "chin")
          leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'American'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#EFB509", popup = ~DBA,stroke = FALSE, fillOpacity = 0.5,radius = 5, group = "amer")
          leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'Italian'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#F0810F", popup = ~DBA,stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "ita")
          leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'Japanese'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#E29930", popup = ~DBA,stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "jap")
          leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'Pizza'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#EB8A3E", popup = ~DBA,stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "piz")
          leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'Others'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#EAB364", stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "oth")
          
          ### market
          leafletProxy("map2", data = market[which(market$type == 'Pharmacy'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#5C821A", stroke = FALSE, fillOpacity = 1,radius = 5,  group = "pha")
          leafletProxy("map2", data = market[which(market$type == 'Geocery'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#C6D166", stroke = FALSE, fillOpacity = 1,radius = 5,  group = "gro")
          
          ### Cinema
          leafletProxy("map2", data = art[which(art$type == 'movie'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#A1D6E2", stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "cin")
          leafletProxy("map2", data = art[which(art$type == 'art'),]) %>%
            addCircleMarkers(~lon,~lat,color = "#1995AD", stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "the")
          
          ### Crime
          leafletProxy("map2", data = crime[which(crime$Desc == "ROBBERY"),]) %>%
            addCircleMarkers(~Longitude,~Latitude,color = "#113743", stroke = FALSE, fillOpacity = 0.5,radius = 2,  group = "rob")
          leafletProxy("map2", data = crime[which(crime$Desc == "PETIT LARCENY"),]) %>%
            addCircleMarkers(~Longitude,~Latitude,color = "#2C4A52", stroke = FALSE, fillOpacity = 0.5,radius = 2,  group = "pl")
          leafletProxy("map2",data = crime[which(crime$Desc == "HARRASSMENT 2"),]) %>%
            addCircleMarkers(~Longitude,~Latitude,color = "#537072", stroke = FALSE, fillOpacity = 0.5,radius = 2,  group = "ha2")
          leafletProxy("map2", data = crime[which(crime$Desc == "GRAND LARCENY"),]) %>%
            addCircleMarkers(~Longitude,~Latitude,color = "#8E9B97", stroke = FALSE, fillOpacity = 0.5,radius = 2,  group = "gl")
          leafletProxy("map2", data = crime[which(crime$Desc == "DANGEROUS DRUGS"),]) %>%
            addCircleMarkers(~Longitude,~Latitude,color = "#E4E3DB", stroke = FALSE, fillOpacity = 0.5,radius = 2,  group = "dd")
          leafletProxy("map2", data = crime[which(crime$Desc == "ASSAULT 3 & RELATED OFFENSES"),]) %>%
            addCircleMarkers(~Longitude,~Latitude,color = "#C5BEBA", stroke = FALSE, fillOpacity = 0.5,radius = 2,  group = "aro")
          leafletProxy("map2", data = crime[which(crime$Desc == "Others"),]) %>%
            addCircleMarkers(~Longitude,~Latitude,color = "#D6C6B9", stroke = FALSE, fillOpacity = 0.5,radius = 2,  group = "coth")
          
          m
        })  
        
        ##########################################################################
        ## Panel 3: recommand map#################################################
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
 
  
        ## Panel *: click on any area, popup text about this zipcode area's information
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

        ## Panel **: Colorful map or not
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
        ## Panel ***: Return to big view
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

        
        
        ##########################################################################
        # Panel 4: recommand2 ####################################################
        ########################################################################## 
        
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








