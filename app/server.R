library(ggmap)

shinyServer(function(input, output) {
        ## Panel 3: leaflet
        output$map <- renderLeaflet({
                # ----- set uo color pallette https://rstudio.github.io/leaflet/colors.html
                # Create a continuous palette function
                pal <- colorNumeric(
                        palette = "Reds",
                        domain = subdat$value
                )
                leaflet(subdat) %>%
                        setView(lng = -73.98928, lat = 40.75042, zoom = 13) %>%
                        addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE))%>%
                        #addTiles()%>%  #colorful map
                        addPolygons(layerId = ~ZIPCODE,
                                    stroke = T, weight=1,
                                    fillOpacity = 0.6,
                                    color = ~pal(value),
                                    highlightOptions = highlightOptions(color='#ff0000', opacity = 0.5, weight = 4, fillOpacity = 0.5,
                                                                        bringToFront = TRUE, sendToBack = TRUE)
                        )%>%
                        
                        addLegend(pal = pal, values = ~value, opacity = 1)
       
        })
        
        observeEvent(input$map_shape_click, {
                click <- input$map_shape_click
                zip<-paste("ZIPCODE: ", revgeocode(as.numeric(c(click$lng,click$lat)),output="more")$postal_code)
                price_avg<-paste("Average Price: $",
                             avg_price_zip.df[avg_price_zip.df$region==as.character(revgeocode(as.numeric(c(click$lng,click$lat)),output="more")$postal_code),"value"],sep="")
                studio_avg<-paste("Studio: $",price[price$region==as.character(revgeocode(as.numeric(c(click$lng,click$lat)),output="more")$postal_code)&price$type=="Studio","avg"],sep="")
                OneB_avg<-paste("1B: $",price[price$region==as.character(revgeocode(as.numeric(c(click$lng,click$lat)),output="more")$postal_code)&price$type=="OneBedroom","avg"],sep="")
                TwoB_avg<-paste("2B: $",price[price$region==as.character(revgeocode(as.numeric(c(click$lng,click$lat)),output="more")$postal_code)&price$type=="TwoBedroom","avg"],sep="")
                ThreeB_avg<-paste("3B: $",price[price$region==as.character(revgeocode(as.numeric(c(click$lng,click$lat)),output="more")$postal_code)&price$type=="ThreeBedroom","avg"],sep="")
                FourB_avg<-paste("4B: $",price[price$region==as.character(revgeocode(as.numeric(c(click$lng,click$lat)),output="more")$postal_code)&price$type=="fOURbEDROOM","avg"],sep="")
                text<-paste(zip,"<br>",
                            price_avg,"<br>",
                            studio_avg,"<br>",
                            OneB_avg,"<br>",
                            TwoB_avg,"<br>",
                            ThreeB_avg,"<br>",
                            FourB_avg,"<br>")
                proxy <- leafletProxy("map")
                proxy %>% clearPopups() %>%
                        addPopups(click$lng, click$lat, text)%>%
                        setView(click$lng,click$lat,zoom=15,options=list(animate=TRUE))
        })
        
        
        
        

})