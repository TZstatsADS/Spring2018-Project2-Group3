library(ggmap)
library(ggplot2)
library(dplyr)
library(DT)

load("../output/price.RData")
load("../output/avg_price_zip.RData")
load("../output/subdat.RData")
bus <- read.csv("../data/bus_stop.csv",as.is = T)
subway <- read.csv("../data/subwayinfo.csv", as.is = T)
restaurant <- read.csv("../data/res.fil1.csv",as.is = T)
crime <- read.csv("../data/crime_data.csv",as.is = T)
market <- read.csv("../data/market_dxy.csv",as.is = T)
art <- read.csv("../data/theatre_dxy.csv",as.is = T)
rank_all <- read.csv("../data/rank_all.csv",as.is = T)
show <- read.csv("../output/show.csv",as.is = T)
show <- show[,-1]



shinyServer(function(input, output,session) {

       #################################################################
       ##### Panel 1 : summary  ########################################
       #################################################################
        output$map <- renderLeaflet({
                leaflet()%>%
                        setView(lng = -73.98928, lat = 40.75042, zoom = 13)
        })
        
        ## Panel *: heat map###########################################
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
        
        
        ## Panel *: click on any area, popup text about this zipcode area's information#########
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
        
        ## Panel *: Colorful map or not###################################
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
        ## Panel *: Return to big view##################################
        observeEvent(input$click_reset_buttom,{
          if(input$click_reset_buttom){
            leafletProxy("map")%>%
              setView(lng = -73.98928, lat = 40.75042, zoom = 13)%>% 
              clearPopups()
          }
        })
        
        
        #################################################################
        ##### Panel 2 :dot.detail########################################
        #################################################################
        output$map2 <- renderLeaflet({
          m <- leaflet()%>%
            setView(lng = -73.96407, lat = 40.80754, zoom = 16)%>%
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
            addCircleMarkers(~lon,~lat,popup = ~DBA, color = "#EAB364", stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "oth")
          
          ### market
          leafletProxy("map2", data = market[which(market$type == 'Pharmacy'),]) %>%
            addCircleMarkers(~lon,~lat,popup = ~name, color = "#5C821A", stroke = FALSE, fillOpacity = 1,radius = 5,  group = "pha")
          leafletProxy("map2", data = market[which(market$type == 'Geocery'),]) %>%
            addCircleMarkers(~lon,~lat,popup = ~name, color = "#C6D166", stroke = FALSE, fillOpacity = 1,radius = 5,  group = "gro")
          
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
          ### Bus Subway
          marker_opt <- markerOptions(opacity=0.8,riseOnHover=T)
          leafletProxy("map2", data = bus) %>%
            addMarkers(~LONGITUDE,~LATITUDE,popup=~LOCATION,group="bus",options=marker_opt,icon=list(iconUrl='icon/bus.png',iconSize=c(15,15)))
          leafletProxy("map2", data = subway) %>%
            addMarkers(~Station.Longitude,~Station.Latitude,popup=~Station.Name,group="subway",options=marker_opt,icon=list(iconUrl='icon/subway.png',iconSize=c(15,15)))
          
          
          ###  bar
          # leafletProxy("map2", data = bar) %>%
          #  addMarkers(~LONGITUDE,~LATITUDE,popup=~LOCATION,group="bar",options=marker_opt,icon=list(iconUrl='icon/bar.png',iconSize=c(15,15)))
          
          
          
          
          m
        })
        observeEvent(input$check_rest,{
          if(input$check_rest){
            #leafletProxy("map2") %>% showGroup(c("ita", "chin", "amer", "jap", "piz", "oth"))
            insertUI(
              selector = "#facilities",
              where = "afterEnd",
              ui=absolutePanel(id = "rest_ui", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                               top = 280, left = 10, height = ,width = 120,
                               checkboxGroupInput("rest_details",label="Details",
                                                  choices=c("American"="a",
                                                            "Italian"="i",
                                                            "Chinese"="c",
                                                            'Japanese' = 'j',
                                                            'Pizza' = 'p',
                                                            "Others" = "o")#,
                                                  # selected = c("American"="a",
                                                  #              "Italian"="i",
                                                  #              "Chinese"="c",
                                                  #              'Japaness' = 'j',
                                                  #              'Pizza' = 'p',
                                                  #              "Others" = "o")
                               )
              )
            )
            
          }
          else{
            removeUI(
              selector = "#rest_ui"
            )
            leafletProxy("map2") %>% hideGroup(c("ita", "chin", "amer", "jap", "piz", "oth"))
          }
        })
        observeEvent(input$check_tran,{
          if(input$check_tran){
            leafletProxy("map2") %>% showGroup(c("subway", "bus"))
            insertUI(
              selector = "#facilities",
              where = "afterEnd",
              ui=absolutePanel(id = "tran_ui", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                               top = 400, left = 150, height = ,width = 120,
                               checkboxGroupInput("tran_details",label="Details",
                                                  choices=c("Subway"="sub",
                                                            "Bus"="bs"),
                                                  selected = c("Subway"="sub",
                                                               "Bus"="bs")
                               )
              )
            )
            
          }
          else{
            removeUI(
              selector = "#tran_ui"
            )
            leafletProxy("map2") %>% hideGroup(c("subway", "bus"))
          }
        })
        observeEvent(input$check_m,{
          if(input$check_m){
            leafletProxy("map2") %>% showGroup(c("pha", "gro"))
            insertUI(
              selector = "#facilities",
              where = "afterEnd",
              ui=absolutePanel(id = "market_ui", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                               top = , left = 10, height = ,width = 120,
                               checkboxGroupInput("market_details",label="Details",
                                                  choices=c("Pharmacy"="pha",
                                                            "Grocery"="gro"),
                                                  selected = c("Pharmacy"="pha",
                                                               "Grocery"="gro")
                               )
              )
            )
            
          }
          else{
            removeUI(
              selector = "#market_ui"
            )
            leafletProxy("map2") %>% hideGroup(c("pha", "gro"))
          }
        })
        observeEvent(input$check_ct,{
          if(input$check_ct){
            leafletProxy("map2") %>% showGroup(c("cin", "the"))
            insertUI(
              selector = "#facilities",
              where = "afterEnd",
              ui=absolutePanel(id = "ct_ui", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                               top = , left = 10, height = ,width = 120,
                               checkboxGroupInput("ct_details",label="Details",
                                                  choices=c("Cinema"="cin",
                                                            "Theatry"="the"),
                                                  selected = c("Cinema"="cin",
                                                               "Theatry"="the")
                               )
              )
            )
            
          }
          else{
            leafletProxy("map2") %>% hideGroup(c("cin", "the"))
            removeUI(
              selector = "#ct_ui"
            )
            
          }
        })
        observeEvent(input$check_cr,{
          if(input$check_cr){
            leafletProxy("map2") %>% showGroup(c("rob", "pl", "ha2", "gl", "dd", "aro", "coth"))
            insertUI(
              selector = "#facilities",
              where = "afterEnd",
              ui=absolutePanel(id = "cr_ui", class = "panel panel-default", fixed = TRUE, draggable = FALSE,
                               top = , left = 10, height = ,width = 120,
                               checkboxGroupInput("cr_details",label="Details",
                                                  choices=c("ROBBERY" = "rob",
                                                            "PETIT LARCENY" = "pl", 
                                                            "HARRASSMENT 2" = "ha", 
                                                            "GRAND LARCENY" = "gl", 
                                                            "DANGEROUS DRUGS" = "dd",
                                                            "ASSAULT 3 & RELATED OFFENSES" = "aro",
                                                            "Others" = "oth"),
                                                  selected = c("ROBBERY" = "rob",
                                                               "PETIT LARCENY" = "pl", 
                                                               "HARRASSMENT 2" = "ha", 
                                                               "GRAND LARCENY" = "gl", 
                                                               "DANGEROUS DRUGS" = "dd",
                                                               "ASSAULT 3 & RELATED OFFENSES" = "aro",
                                                               "Others" = "oth")
                               )
              )
            )
            
          }
          else{
            removeUI(
              selector = "#cr_ui"
            )
            leafletProxy("map2") %>% hideGroup(c("rob", "pl", "ha2", "gl", "dd", "aro", "coth")) 
          }
        })
        
        
        observeEvent(input$all_types, {
          updateCheckboxInput(session, "check_rest", value = T)
          updateCheckboxInput(session, "check_tran", value = T)
          updateCheckboxInput(session, "check_cb", value = T)
          updateCheckboxInput(session, "check_ct", value = T)
          updateCheckboxInput(session, "check_m", value = T)
          updateCheckboxInput(session, "check_cr", value = T)
          
        })
        observeEvent(input$no_types, {
          updateCheckboxInput(session, "check_rest", value = F)
          updateCheckboxInput(session, "check_tran", value = F)
          updateCheckboxInput(session, "check_cb", value = F)
          updateCheckboxInput(session, "check_ct", value = F)
          updateCheckboxInput(session, "check_m", value = F)
          updateCheckboxInput(session, "check_cr", value = F)
        })
        ### food
        observeEvent(input$rest_details, {
          if("c" %in% input$rest_details) leafletProxy("map2") %>% showGroup("chin")
          else{leafletProxy("map2") %>% hideGroup("chin")}
          if("a" %in% input$rest_details) leafletProxy("map2") %>% showGroup("amer")
          else{leafletProxy("map2") %>% hideGroup("amer")}
          if("i" %in% input$rest_details) leafletProxy("map2") %>% showGroup("ita")
          else{leafletProxy("map2") %>% hideGroup("ita")}
          if("j" %in% input$rest_details) leafletProxy("map2") %>% showGroup("jap")
          else{leafletProxy("map2") %>% hideGroup("jap")}
          if("p" %in% input$rest_details) leafletProxy("map2") %>% showGroup("piz")
          else{leafletProxy("map2") %>% hideGroup("piz")}
          if("o" %in% input$rest_details) leafletProxy("map2") %>% showGroup("oth")
          else{leafletProxy("map2") %>% hideGroup("oth")}
        }, ignoreNULL = FALSE)
        
        
        ### market
        observeEvent(input$market_details, {
          if("pha" %in% input$market_details) leafletProxy("map2") %>% showGroup("pha")
          else{leafletProxy("map2") %>% hideGroup("pha")}
          if("gro" %in% input$market_details) leafletProxy("map2") %>% showGroup("gro")
          else{leafletProxy("map2") %>% hideGroup("gro")}
        }, ignoreNULL = FALSE)
        
        ####ct
        observeEvent(input$ct_details, {
          if("cin" %in% input$ct_details) leafletProxy("map2") %>% showGroup("cin")
          else{leafletProxy("map2") %>% hideGroup("cin")}
          if("the" %in% input$ct_details) leafletProxy("map2") %>% showGroup("the")
          else{leafletProxy("map2") %>% hideGroup("the")}
        }, ignoreNULL = FALSE)
        ###cr
        observeEvent(input$cr_details, {
          if("rob" %in% input$cr_details) leafletProxy("map2") %>% showGroup("rob")
          else{leafletProxy("map2") %>% hideGroup("rob")}
          if("pl" %in% input$cr_details) leafletProxy("map2") %>% showGroup("pl")
          else{leafletProxy("map2") %>% hideGroup("pl")}
          if("ha" %in% input$cr_details) leafletProxy("map2") %>% showGroup("ha2")
          else{leafletProxy("map2") %>% hideGroup("ha2")}
          if("gl" %in% input$cr_details) leafletProxy("map2") %>% showGroup("gl")
          else{leafletProxy("map2") %>% hideGroup("gl")}
          if("dd" %in% input$cr_details) leafletProxy("map2") %>% showGroup("dd")
          else{leafletProxy("map2") %>% hideGroup("dd")}
          if("aro" %in% input$cr_details) leafletProxy("map2") %>% showGroup("aro")
          else{leafletProxy("map2") %>% hideGroup("aro")}
          if("oth" %in% input$cr_details) leafletProxy("map2") %>% showGroup("coth")
          else{leafletProxy("map2") %>% hideGroup("coth")}
        }, ignoreNULL = FALSE)
        #### trans
        observeEvent(input$tran_details, {
          if("bs" %in% input$tran_details) leafletProxy("map2") %>% showGroup("bus")
          else{leafletProxy("map2") %>% hideGroup("bus")}
          if("sub" %in% input$tran_details) leafletProxy("map2") %>% showGroup("subway")
          else{leafletProxy("map2") %>% hideGroup("subway")}
        }, ignoreNULL = FALSE)
        
        ### bar
        # observeEvent(input$check_cb)
        
        
        ##########################################################################
        ## Panel 3: recommand ####################################################
        ########################################################################## 
        
        ##map
        output$map3 <- renderLeaflet({
          leaflet()%>%
            setView(lng = -73.98097, lat = 40.7562, zoom = 12)%>%
            addProviderTiles("Stamen.TonerLite")
        })
 
        observeEvent(input$click_back_buttom,{
          if(input$click_back_buttom){
            leafletProxy("map3")%>%
              setView(lng = -73.98097, lat = 40.7562, zoom = 12)
          }
        })
        
        ##Clear
        observeEvent(input$no_rec2, {
          updateSliderInput(session, "check2_pr",value = 5400)
          updateSelectInput(session, "check2_ty",selected="")
          updateSelectInput(session, "check2_re",selected="")
          updateSelectInput(session, "check2_tr",selected = "Who Cares")
          updateSelectInput(session, "check2_cb",selected = "Who Cares")
          updateSelectInput(session, "check2_ct",selected = "1")
          updateSelectInput(session, "check2_ma",selected = "1")
        })
        
        
        ##Table

        
        output$recom <- renderDataTable(show, options = list("sScrollX" = "100%", "bLengthChange" = FALSE))

        
        
        observeEvent(input$no_rec2, {
          updateSliderInput(session, "check2_pr",value = 5400)
          updateSelectInput(session, "check2_ty",selected="")
          updateSelectInput(session, "check2_re",selected="")
          updateSelectInput(session, "check2_tr",selected = "Who Cares")
          updateSelectInput(session, "check2_cb",selected = "Who Cares")
          updateSelectInput(session, "check2_ct",selected = "1")
          updateSelectInput(session, "check2_ma",selected = "1")
        })
        
        # 
        # reactive(
        #   cond.apt.0 <- if("Studio" %in% input$check2_ty){paste0("Studio <= ", input$check2_pr)
        #   } else{"Studio <= 5400"})
        # reactive(
        #   cond.apt.1 <- if("1B" %in% input$check2_ty){paste0("X1B <= ", input$check2_pr)
        #   } else{"X1B <= 5400"})
        # reactive(
        #   cond.apt.2 <- if("2B" %in% input$check2_ty) {paste0("X2B <= ", input$check2_pr)
        #   } else{"X2B <= 5400"})
        # reactive(
        #   cond.apt.3 <- if("3B" %in% input$check2_ty) {paste0("X3B <= ", input$check2_pr)
        #   } else{"X3B <= 5400"})
        # reactive(
        #   cond.apt.4 <- if("4B" %in% input$check2_ty) {paste0("X4B <= ", input$check2_pr)
        #   } else{"X4B <= 5400"})
        # 
        # 
        # reactive(
        #   cond.ame <- if("American" %in% input$check2_re){"ranking.American <= 23"
        #   } else {"ranking.American <= 46"})
        # reactive(
        #   cond.chi <- if("Chinese" %in% input$check2_re) {"ranking.Chinese <= 23"
        #   } else {"ranking.Chinese <= 46"})
        # reactive(
        #   cond.ita <- if("Italian" %in% input$check2_re) {"ranking.Italian <= 23"
        #   } else {"ranking.Italian <= 46"})
        # reactive(
        #   cond.jap <- if("Japanese" %in% input$check2_re) {"ranking.Japanese <= 23"
        #   } else {"ranking.Japanese <= 46"})
        # reactive(
        #   cond.piz <- if("Pizza" %in% input$check2_re) {"ranking.Pizza <= 23"
        #   } else {"ranking.Pizza <= 46"})
        # reactive(
        #   cond.oth <- if("Others" %in% input$check2_re) {"ranking.Others <= 23"
        #   } else {"ranking.Others <= 46"})
        # 
        # 
        # reactive(
        #   trans.fil <- if(input$check2_tr == "It's everything"){
        #     1:16
        #   } else if(input$check2_tr == "Emmm"){
        #     1:32
        #   } else {
        #     c(1:46, NA)
        #   }
        # )
        # 
        # reactive(
        #   club.fil <- if(input$check2_cb == "Let's party!"){1:16
        #   } else if(input$check2_cb == "Emmm"){
        #     1:32
        #   } else {
        #     c(1:46, NA)
        #   }
        # )
        # 
        # reactive(
        #   theatre.fil <- if(input$check2_ct == "3"){1:16
        #   } else if(input$check2_ct == "2"){
        #     1:32
        #   } else {
        #     c(1:46, NA)
        #   }
        # )
        # 
        # reactive(
        #   market.fil <- if(input$check2_ma == "3"){
        #     1:16
        #   } else if(input$check2_ma == "2"){
        #     1:32
        #   } else {
        #     c(1:46, NA)
        #   }
        # )
        # 
        # reactive(
        #   areas <- rank_all %>%
        #     filter(eval(parse(cond.apt.0)), eval(parse(cond.apt.1)), eval(parse(cond.apt.2)),
        #            eval(parse(cond.apt.3)), eval(parse(cond.apt.4)),
        #            eval(parse(cond.ame)), eval(parse(cond.chi)), eval(parse(cond.ita)),
        #            eval(parse(cond.jap)), eval(parse(cond.piz)), eval(parse(cond.oth)),
        #            ranking.trans %in% trans.fil, ranking.bars %in% club.fil,
        #            ranking.theatre %in% theatre.fil, ranking.market %in% market.fil
        #     ) %>%
        #     select(zipcode)
        # )
        # 
        # 
 

})








