library(ggmap)
library(ggplot2)
library(dplyr)
library(DT)

load("./output/price.RData")
load("./output/avg_price_zip.RData")
load("./output/subdat.RData")
bus <- read.csv("./data/bus_stop.csv",as.is = T)
subway <- read.csv("./data/subwayinfo.csv", as.is = T)
restaurant <- read.csv("./data/res.fil1.csv",as.is = T)
crime <- read.csv("./data/crime_data.csv",as.is = T)
market <- read.csv("./data/market_dxy.csv",as.is = T)
art <- read.csv("./data/theatre_dxy.csv",as.is = T)
rank_all <- read.csv("./data/rank_all.csv",as.is = T)
show <- read.csv("./output/show.csv",as.is = T)
show <- show[,-1]
bar1 <- read.csv("./data/Bars.csv", as.is = T)
bar2 <- read.csv("./data/Clubs.csv", as.is = T)
bar3 <- read.csv("./data/Wine.csv", as.is = T)
bar <- rbind(bar1, bar2, bar3)



shinyServer(function(input, output,session){
     #################################################################
     ##### Panel 1 : summary  ########################################
     #################################################################
     output$map <- renderLeaflet({
       leaflet()%>%
         setView(lng = -73.98928, lat = 40.75042, zoom = 13)%>%
         addProviderTiles("Stamen.TonerLite")
    
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
       ## track
       if(input$click_multi == FALSE) leafletProxy('map') %>%clearGroup("click")
       click <- input$map_shape_click
       leafletProxy('map')%>%
         addMarkers(click$lng, click$lat, group="click", icon=list(iconUrl='icon/leaves.png',iconSize=c(60,60)))
    
       ##info
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
         addCircleMarkers(~lon,~lat,color = "#FFEC5C", popup = ~DBA, stroke = FALSE, fillOpacity = 0.5,radius = 5, group  = "chin")
       leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'American'),]) %>%
         addCircleMarkers(~lon,~lat,color = "#C8000A", popup = ~DBA,stroke = FALSE, fillOpacity = 0.5,radius = 5, group = "amer")
       leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'Italian'),]) %>%
         addCircleMarkers(~lon,~lat,color = "#F9BA32", popup = ~DBA,stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "ita")
       leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'Japanese'),]) %>%
         addCircleMarkers(~lon,~lat,color = "#D35C37", popup = ~DBA,stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "jap")
       leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'Pizza'),]) %>%
         addCircleMarkers(~lon,~lat,color = "#E8A735", popup = ~DBA,stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "piz")
       leafletProxy("map2", data = restaurant[which(restaurant$CUISINE.DESCRIPTION == 'Others'),]) %>%
         addCircleMarkers(~lon,~lat,popup = ~DBA, color = "#E2C499", stroke = FALSE, fillOpacity = 0.5,radius = 5,  group = "oth")
    
       ### market
       leafletProxy("map2", data = market[which(market$type == 'Pharmacy'),]) %>%
         addCircleMarkers(~lon,~lat,popup = ~name, color = "#5C821A", stroke = FALSE, fillOpacity = 1,radius = 5,  group = "pha")
       leafletProxy("map2", data = market[which(market$type == 'Grocery'),]) %>%
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
       
       ## Bus Subway
       marker_opt <- markerOptions(opacity=0.8,riseOnHover=T)
       leafletProxy("map2", data = bus) %>%
         addMarkers(~LONGITUDE,~LATITUDE,popup=~LOCATION,group="bus",options=marker_opt,icon=list(iconUrl='icon/bus.png',iconSize=c(15,15)))
       leafletProxy("map2", data = subway[subway$zipcode%in%bus$zipcode, ]) %>%
         addMarkers(~Station.Longitude,~Station.Latitude,popup=~Station.Name,group="subway",options=marker_opt,icon=list(iconUrl='icon/subway.png',iconSize=c(15,15)))
    
    
       ###  bar
       marker_opt <- markerOptions(opacity=1,riseOnHover=T)
       leafletProxy("map2", data = bar[bar$Zip %in% bus$zipcode,]) %>%
         addMarkers(~Longitude,~Latitude,popup = ~Doing.Business.As..DBA.,group="bar",options=marker_opt,icon=list(iconUrl='icon/bar.png',iconSize=c(15,15)))
    
    
       m
     })

  
     ##select all
     observeEvent(input$all_types, {
       updateSelectInput(session, "check_rest1", selected = list("American", "Chinese", "Italian", "Japanese", "Pizza", "Others"))
       updateSelectInput(session, "check_tran1", selected =  list("Bus","Subway"))
       updateCheckboxInput(session, "check_cb1", value = T)
       updateSelectInput(session, "check_ct1", selected =  list("Cinema","Theatre"))
       updateSelectInput(session, "check_m1", selected =  list("Pharmacy","Grocery"))
       updateSelectInput(session, "check_cr1", selected =  list("ROBBERY", "PETIT LARCENY", "HARRASSMENT 2", "GRAND LARCENY", "DANGEROUS DRUGS",
                                                                "ASSAULT 3 & RELATED OFFENSES","Others"))
     })
     
     ##clear all
     observeEvent(input$no_types, {
       updateSelectInput(session, "check_rest1", selected =  "")
       updateSelectInput(session, "check_tran1", selected =  "")
       updateCheckboxInput(session, "check_cb1", value = F)
       updateSelectInput(session, "check_ct1", selected =  "")
       updateSelectInput(session, "check_m1", selected =  "")
       updateSelectInput(session, "check_cr1", selected =  "")
     })
  
     ##reset all
     observeEvent(input$click_reset_dot,{
       if(input$click_reset_dot){
         leafletProxy("map2")%>%
           setView(lng = -73.96407, lat = 40.80754, zoom = 16)
       }
     })

     
     
  ### food
  observeEvent(input$check_rest1, {
    if("Chinese" %in% input$check_rest1) leafletProxy("map2") %>% showGroup("chin")
    else{leafletProxy("map2") %>% hideGroup("chin")}
    if("American" %in% input$check_rest1) leafletProxy("map2") %>% showGroup("amer")
    else{leafletProxy("map2") %>% hideGroup("amer")}
    if("Italian" %in% input$check_rest1) leafletProxy("map2") %>% showGroup("ita")
    else{leafletProxy("map2") %>% hideGroup("ita")}
    if("Japanese" %in% input$check_rest1) leafletProxy("map2") %>% showGroup("jap")
    else{leafletProxy("map2") %>% hideGroup("jap")}
    if("Pizza" %in% input$check_rest1) leafletProxy("map2") %>% showGroup("piz")
    else{leafletProxy("map2") %>% hideGroup("piz")}
    if("Others" %in% input$check_rest1) leafletProxy("map2") %>% showGroup("oth")
    else{leafletProxy("map2") %>% hideGroup("oth")}
  }, ignoreNULL = FALSE)
  
  
  ### market
  observeEvent(input$check_m1, {
    if("Pharmacy" %in% input$check_m1) leafletProxy("map2") %>% showGroup("pha")
    else{leafletProxy("map2") %>% hideGroup("pha")}
    if("Grocery" %in% input$check_m1) leafletProxy("map2") %>% showGroup("gro")
    else{leafletProxy("map2") %>% hideGroup("gro")}
  }, ignoreNULL = FALSE)
  
  ####ct
  observeEvent(input$check_ct1, {
    if("Cinema" %in% input$check_ct1) leafletProxy("map2") %>% showGroup("cin")
    else{leafletProxy("map2") %>% hideGroup("cin")}
    if("Theatre" %in% input$check_ct1) leafletProxy("map2") %>% showGroup("the")
    else{leafletProxy("map2") %>% hideGroup("the")}
  }, ignoreNULL = FALSE)
  ###cr
  observeEvent(input$check_cr1, {
    if("ROBBERY" %in% input$check_cr1) leafletProxy("map2") %>% showGroup("rob")
    else{leafletProxy("map2") %>% hideGroup("rob")}
    if("PETIT LARCENY" %in% input$check_cr1) leafletProxy("map2") %>% showGroup("pl")
    else{leafletProxy("map2") %>% hideGroup("pl")}
    if("HARRASSMENT 2" %in% input$check_cr1) leafletProxy("map2") %>% showGroup("ha2")
    else{leafletProxy("map2") %>% hideGroup("ha2")}
    if("GRAND LARCENY" %in% input$check_cr1) leafletProxy("map2") %>% showGroup("gl")
    else{leafletProxy("map2") %>% hideGroup("gl")}
    if("DANGEROUS DRUGS" %in% input$check_cr1) leafletProxy("map2") %>% showGroup("dd")
    else{leafletProxy("map2") %>% hideGroup("dd")}
    if("ASSAULT 3 & RELATED OFFENSES" %in% input$check_cr1) leafletProxy("map2") %>% showGroup("aro")
    else{leafletProxy("map2") %>% hideGroup("aro")}
    if("Others" %in% input$check_cr1) leafletProxy("map2") %>% showGroup("coth")
    else{leafletProxy("map2") %>% hideGroup("coth")}
  }, ignoreNULL = FALSE)
  #### trans
  observeEvent(input$check_tran1, {
    if("Bus" %in% input$check_tran1) leafletProxy("map2") %>% showGroup("bus")
    else{leafletProxy("map2") %>% hideGroup("bus")}
    if("Subway" %in% input$check_tran1) leafletProxy("map2") %>% showGroup("subway")
    else{leafletProxy("map2") %>% hideGroup("subway")}
  }, ignoreNULL = FALSE)
  
  ### bar
   observeEvent(input$check_cb1, {
     if(input$check_cb1) leafletProxy("map2") %>% showGroup("bar")
     else{leafletProxy("map2") %>% hideGroup("bar")}
   })
  
  
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
    updateSelectInput(session, "check2_tr",selected = "Who Cares.")
    updateSelectInput(session, "check2_cb",selected = "I'm allergic.")
    updateSelectInput(session, "check2_ct",selected = "Netflix for life.")
    updateSelectInput(session, "check2_ma",selected = "Just Amazon.")
  })
  
  
  
  ##Recommand
  areas  <- reactive({
    cond.apt.0 <- if(is.null(input$check2_ty)){ paste0("Studio <= ", input$check2_pr, " |is.na(Studio) == TRUE")
    } else if("Studio" %in% input$check2_ty){paste0("Studio <= ", input$check2_pr)
    } else{"Studio <= 5400 |is.na(Studio) == TRUE"}
    
    cond.apt.1 <- if(is.null(input$check2_ty)){ paste0("X1B <= ", input$check2_pr, " |is.na(X1B) == TRUE")
    } else if("1B" %in% input$check2_ty){paste0("X1B <= ", input$check2_pr)
    } else{"X1B <= 5400 |is.na(X1B) == TRUE"}
    
    cond.apt.2 <- if(is.null(input$check2_ty)){paste0("X2B <= ", input$check2_pr, " |is.na(X2B) == TRUE")
    } else if("2B" %in% input$check2_ty) {paste0("X2B <= ", input$check2_pr)
    } else{"X2B <= 5400 |is.na(X2B) == TRUE"}
    
    cond.apt.3 <- if(is.null(input$check2_ty)){paste0("X3B <= ", input$check2_pr, " |is.na(X3B) == TRUE")
    } else if("3B" %in% input$check2_ty) {paste0("X3B <= ", input$check2_pr)
    } else{"X3B <= 5400 |is.na(X3B) == TRUE"}
    
    cond.apt.4 <-  if(is.null(input$check2_ty)){paste0("X4B <= ", input$check2_pr, " |is.na(X4B) == TRUE")
    } else if("4B" %in% input$check2_ty) {paste0("X4B <= ", input$check2_pr)
    } else{"X4B <= 5400 |is.na(X4B) == TRUE"}
    
    cond.ame <- if(is.null(input$check2_re)){"ranking.American <= 46 |is.na(ranking.American) == TRUE"
    } else if("American" %in% input$check2_re){"ranking.American <= 23"
    } else {"ranking.American <= 46 |is.na(ranking.American) == TRUE"}
    
    cond.chi <- if(is.null(input$check2_re)){"ranking.Chinese <= 46 |is.na(ranking.Chinese) == TRUE"
    } else if("Chinese" %in% input$check2_re) {"ranking.Chinese <= 23"
    } else {"ranking.Chinese <= 46 |is.na(ranking.Chinese) == TRUE"}
    
    cond.ita <-  if(is.null(input$check2_re)){"ranking.Italian <= 46 |is.na(ranking.Italian) == TRUE"
    } else if("Italian" %in% input$check2_re) {"ranking.Italian <= 23"
    } else {"ranking.Italian <= 46 |is.na(ranking.Italian) == TRUE"}
    
    cond.jap <- if(is.null(input$check2_re)){"ranking.Japenses <= 46 |is.na(ranking.Japenses) == TRUE"
    } else if("Japanese" %in% input$check2_re) {"ranking.Japenses <= 23"
    } else {"ranking.Japenses <= 46 |is.na(ranking.Japenses) == TRUE"}
    
    cond.piz <- if(is.null(input$check2_re)){"ranking.Pizza <= 46 |is.na(ranking.Pizza) == TRUE"
    } else if("Pizza" %in% input$check2_re) {"ranking.Pizza <= 23"
    } else {"ranking.Pizza <= 46 |is.na(ranking.Pizza) == TRUE"}
    
    cond.oth <- if(is.null(input$check2_re)){"ranking.Others <= 46 |is.na(ranking.Others) == TRUE"
    } else if("Others" %in% input$check2_re) {"ranking.Others <= 23"
    } else {"ranking.Others <= 46 |is.na(ranking.Others) == TRUE"}
    
    trans.fil <- if(input$check2_tr == "It's everything."){
      1:16
    } else if(input$check2_tr == "Emmm."){
      1:32
    } else {
      c(1:46, NA)
    }
    
    club.fil <- if(input$check2_cb == "Let's party!"){1:16
    } else if(input$check2_cb == "Drink one or two."){
      1:32
    } else {
      c(1:46, NA)
    }
    
    theatre.fil<- if(input$check2_ct == "Theatre goers."){1:16
    } else if(input$check2_ct == "It depends."){
      1:32
    } else {
      c(1:46, NA)
    }
    
    market.fil <- if(input$check2_ma == "Love it!"){
      1:16
    } else if(input$check2_ma == "It depends."){
      1:32
    } else {
      c(1:46, NA)
    }
    
    areas <- (rank_all %>%
                filter(eval(parse(text = cond.apt.0)), eval(parse(text = cond.apt.1)), eval(parse(text = cond.apt.2)),
                       eval(parse(text = cond.apt.3)), eval(parse(text = cond.apt.4)),
                       eval(parse(text = cond.ame)), eval(parse(text = cond.chi)), eval(parse(text = cond.ita)),
                       eval(parse(text = cond.jap)), eval(parse(text = cond.piz)), eval(parse(text = cond.oth)),
                       ranking.trans %in% trans.fil, ranking.bar %in% club.fil,
                       ranking.theatre %in% theatre.fil, ranking.market %in% market.fil
                ) %>%
                select(zipcode))[,1]
    return(areas)
  })
  
  
  output$recom <- renderDataTable(show %>%
                                    filter(
                                      Zipcode %in% areas()
                                    ),
                                  options = list("sScrollX" = "100%", "bLengthChange" = FALSE)) 
  ##recommad map
  observe({
    if(length(areas())!=0){
      leafletProxy("map3")%>%clearGroup(group="new_added")%>% 
        addPolygons(data=subset(subdat, subdat$ZIPCODE%in% areas()),
                    weight = 2,
                    color = "#34675C",
                    fillColor = "#B3C100",
                    fillOpacity=0.7,
                    group="new_added",
                    noClip = TRUE, label = ~ZIPCODE)
    }
    
    else{
      leafletProxy("map3")%>%clearGroup(group="new_added")
    }
  })
  
  
     ##########################################################################
     ## Panel 4: compare ######################################################
     ########################################################################## 
     observeEvent(input$click_jump_next,{
       if(input$click_jump_next){
         updateTabsetPanel(session, "inTabset",selected = "Compare")
       }
     })

  
    ##Plot restaurant
    output$pic_re <- renderPlot({
      x <- rank_all%>%
        filter(zipcode %in% areas()) %>%
        select("zipcode","count.Chinese","count.American",
               "count.Italian","count.Japenses","count.Pizza","count.Others")
      x <- melt(x,id.vars = "zipcode")
      ggplot(x, aes(x = as.factor(zipcode), y=value, fill=variable)) +
        geom_bar(stat="identity") +
        scale_fill_manual(values=c("#D24136","#EFB509","#F0810F","#E29930","#EB8A3E","#EAB364"),labels = c("Chinese","American","Italian","Japenses","Pizza","Others"),name="Restaurant") +
        xlab("\nZipcode") +
        ylab("Count\n") +
        theme_bw()+
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
    })
  
    ##Plot market
    output$pic_ma <- renderPlot({
      x <- rank_all%>%
        filter(zipcode %in% areas()) %>%
        select("zipcode","count.pharmacy","count.grocery")
      x <- melt(x,id.vars = "zipcode")
      ggplot(x, aes(x = as.factor(zipcode), y=value, fill=variable)) +
        geom_bar(stat="identity") +
        scale_fill_manual(values=c("#5C821A","#C6D166"),labels = c("Pharmacy","Geocery"),name="Market") +
        xlab("\nZipcode") +
        ylab("Count\n") +
        theme_bw()+
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
    })
    
    ##Plot theatre
    output$pic_th <- renderPlot({
      x <- rank_all%>%
        filter(zipcode %in% areas()) %>%
        select("zipcode","count.movie","count.art")
      x <- melt(x,id.vars = "zipcode")
      ggplot(x, aes(x = as.factor(zipcode), y=value, fill=variable)) +
        geom_bar(stat="identity") +
        scale_fill_manual(values=c("#A1D6E2","#1995AD"),labels = c("Cinema","Theatre"),name="Cinema/Theatre") +
        xlab("\nZipcode") +
        ylab("Count\n") +
        theme_bw()+
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
    })
    
    ##Plot crime
    output$pic_cr <- renderPlot({
      x <- rank_all%>%
        filter(zipcode %in% areas()) %>%
        select("zipcode","rob.count","pet.count","har.count","gra.count","dan.count","as.count","oth.count")
      x <- melt(x,id.vars = "zipcode")
      ggplot(x, aes(x = as.factor(zipcode), y=value, fill=variable)) +
        geom_bar(stat="identity") +
        scale_fill_manual(values=c("#113743","#2C4A52","#537072","#8E9B97","#E4E3DB","#C5BEBA","#D6C6B9"),labels = c("ROBBERY","PETIT LARCENY","HARRASSMENT 2","GRAND LARCENY","DANGEROUS DRUGS","ASSAULT","Others"),name="Crime") +
        xlab("\nZipcode") +
        ylab("Count\n") +
        theme_bw()+
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
    })
    
    ##Plot transportation
    output$pic_tr <- renderPlot({
      x <- rank_all%>%
        filter(zipcode %in% areas()) %>%
        select("zipcode","count.bus","count.subway")
      x <- melt(x,id.vars = "zipcode")
      ggplot(x, aes(x = as.factor(zipcode), y=value, fill=variable)) +
        geom_bar(stat="identity") +
        scale_fill_manual(values=c("#CE5A57","#78A5A3"),labels = c("Bus","Subway"),name="Transportation") +
        xlab("\nZipcode") +
        ylab("Count\n") +
        theme_bw()+
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
    })
    
    ##Plot bar
    output$pic_ba <- renderPlot({
      x <- rank_all%>%
        filter(zipcode %in% areas()) %>%
        select("zipcode", "count.bar")
      ggplot(x, aes(x = as.factor(zipcode), y = count.bar)) +
        geom_bar(stat = "identity",fill = "#F18D9E")+
        xlab("\nZipcode") +
        ylab("Count\n")+
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
    })
    
    
})



