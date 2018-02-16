library(ggmap)
library(ggplot2)

shinyServer(function(input, output,session) {
        ## Panel 1: basic map 
        output$map <- renderLeaflet({
                leaflet()%>%
                        setView(lng = -73.98928, lat = 40.75042, zoom = 13)
        })
        output$map2 <- renderLeaflet({
                leaflet()%>%
                        setView(lng = -73.98928, lat = 40.75042, zoom = 13)%>%
                        addProviderTiles("Stamen.TonerHybrid")
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
                subway_count<-paste("How many Subway: ",subway[subway$zipcode==zip_sel,"count"],sep="")
                bus_count<-paste("How many Bus: ",bus[bus$zipcode==zip_sel,"count"],sep="")
                leafletProxy("map")%>%
                        setView(click$lng,click$lat,zoom=14,options=list(animate=TRUE))
                output$zip_text<-renderText({zip})
                output$avgprice_text<-renderText({price_avg})
                output$avgstudio_text<-renderText({studio_avg})
                output$avg1b_text<-renderText(({OneB_avg}))
                output$avg2b_text<-renderText(({TwoB_avg}))
                output$avg3b_text<-renderText(({ThreeB_avg}))
                output$avg4b_text<-renderText(({FourB_avg}))
                output$subway_text<-renderText({subway_count})
                output$bus_text<-renderText({bus_count})
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

 

})








