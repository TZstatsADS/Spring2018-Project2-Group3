library(shiny)
library(choroplethr)
library(choroplethrZip)
library(dplyr)
library(leaflet)
library(maps)
library(rgdal)
library(zipcode)
setwd("/Users/apple/Documents/2018SpringCourse/Applied Data Science/Spring2018-Project2-Group3")
load("./output/avg_price.RData")

shinyServer(function(input, output) {
        ## Panel 1: leaflet
        output$map <- renderLeaflet({
                avg_price.df.sel=avg_price.df
        # From https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u/data
                NYCzipcodes <- readOGR("./data/ZIP_CODE_040114.shp",
                                       #layer = "ZIP_CODE", 
                                       verbose = FALSE)
        
                selZip <- subset(NYCzipcodes, NYCzipcodes$ZIPCODE %in% avg_price.df.sel$region)
        
        # ----- Transform to EPSG 4326 - WGS84 (required)
                subdat<-spTransform(selZip, CRS("+init=epsg:4326"))
        
        # ----- save the data slot
                subdat_data=subdat@data[,c("ZIPCODE", "POPULATION")]
                subdat.rownames=rownames(subdat_data)
                subdat_data=
                        subdat_data%>%left_join(avg_price.df, by=c("ZIPCODE"="region"))
                rownames(subdat_data)=subdat.rownames
        
        # ----- to write to geojson we need a SpatialPolygonsDataFrame
                subdat<-SpatialPolygonsDataFrame(subdat, data=subdat_data)
        # -----
                data(zipcode)
                zip.sel.latlng=zipcode%>%
                        inner_join(avg_price.df.sel,by=c("zip"="region"))
                
                
                
        # ----- set uo color pallette https://rstudio.github.io/leaflet/colors.html
        # Create a continuous palette function
                pal <- colorNumeric(
                        palette = "Reds",
                        domain = subdat$value
                )
        
                leaflet(subdat) %>%
                        addTiles()%>%
                        setView(-73.98928, 40.75042, zoom = 12)%>%
                        addProviderTiles(providers$CartoDB.Positron)%>%
                        addPolygons(
                                stroke = T, weight=1,
                                fillOpacity = 0.6,
                                color = ~pal(value)
                        )%>%
                        addCircleMarkers(lat = zip.sel.latlng$latitude, lng =zip.sel.latlng$longitude, 
                                         radius = 5, popup = paste("Zipcode:",subdat@data[order(subdat@data$ZIPCODE),]$ZIPCODE,"  ","Average Price:",as.character(subdat@data[order(subdat@data$ZIPCODE),]$value)), 
                                         stroke = FALSE, fillOpacity = 0.8,
                                         clusterOptions = markerClusterOptions()) #%>% 
                        #addPopups(zip.sel.latlng$longitude, zip.sel.latlng$latitude,as.character(subdat@data[order(subdat@data$ZIPCODE),]$value)
                        #)
                        
        })


        
        
        })

