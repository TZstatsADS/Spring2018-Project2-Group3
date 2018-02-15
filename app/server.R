library(ggmap)
library(ggplot2)

shinyServer(function(input, output) {
        ## Panel 1: basic map 
        output$map <- renderLeaflet({
                leaflet()%>%
                        setView(lng = -73.98928, lat = 40.75042, zoom = 13)
        })
        
        ## Panel 2: different map functions
        observeEvent(input$app_function,{
                if(input$app_function=="smry"){
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
                                                                                bringToFront = TRUE, sendToBack = TRUE)
                                )%>%
                                addLegend(pal = pal, values = ~value, opacity = 1)
                }
                if(input$app_function=="dd"){
                        insertUI(
                                # -----重新规划构图，显示侧边栏……
                        )
                }
                if(input$app_function=="rcm"){
                        insertUI(
                                # -----推荐界面
                        ) 
                }
        })    
  
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
                subway_count<-paste("How many Subway: ",subway[subway$zipcode==zip_sel,"count"],sep="")
                bus_count<-paste("How many Bus: ",bus[bus$zipcode==zip_sel,"count"],sep="")
                text<-paste(zip,"<br>",
                            price_avg,"<br>",
                            studio_avg,"<br>",
                            OneB_avg,"<br>",
                            TwoB_avg,"<br>",
                            ThreeB_avg,"<br>",
                            FourB_avg,"<br>",
                            subway_count,"<br>",
                            bus_count)
                leafletProxy("map")%>% 
                        clearPopups() %>%
                        addPopups(click$lng, click$lat, text)%>%
                        setView(click$lng,click$lat,zoom=15,options=list(animate=TRUE))
        })
        ## Panel 3: 
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
        


})
