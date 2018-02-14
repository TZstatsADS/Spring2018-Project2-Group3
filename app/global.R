library(shiny)
library(sp)
library(choroplethr)
library(choroplethrZip)
library(dplyr)
library(leaflet)
library(maps)
library(rgdal)

setwd("/Users/apple/Documents/2018SpringCourse/Applied Data Science/Spring2018-Project2-Group3")
## Read all five types of apartments and their rent price in 2017

price_files <- list.files(path = "./data/rental price",full.names = T,pattern = "Zip_MedianRentalPrice*")
rent_type <- c("OneBedroom","TwoBedroom","ThreeBedroom","FourBedroom","FiveBedroom","Studio")
price <- data.frame()
for(i in 1:6){
        tmp<-read.csv(price_files[i])
        tmp$type<-rent_type[i]
        tmp<-tmp[tmp$Metro=="New York"&tmp$CountyName=="New York",c("RegionName","X2017.01","X2017.02","X2017.03","X2017.04","X2017.05","X2017.06","X2017.07","X2017.08","X2017.09","X2017.10","X2017.11","X2017.12","type")]
        price<-rbind(price,tmp)
}
price<-price%>%
        filter(RegionName>0)%>%
        mutate(region=as.character(RegionName))
price$avg<-round(apply(price[,2:13],1,mean))
avg_price_zip.df<-price[,c("region","avg")]%>%
        group_by(region)%>%
        summarise(
                value=mean(avg)
        )
save(avg_price_zip.df, file="./output/avg_price_zip.RData")

avg_price_zip.df.sel=avg_price_zip.df
# From https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u/data
NYCzipcodes <- readOGR("./data/ZIP_CODE_040114.shp",
                       #layer = "ZIP_CODE", 
                       verbose = FALSE)

selZip <- subset(NYCzipcodes, NYCzipcodes$ZIPCODE %in% avg_price_zip.df.sel$region)

# ----- Transform to EPSG 4326 - WGS84 (required)
subdat<-spTransform(selZip, CRS("+init=epsg:4326"))

# ----- save the data slot
subdat_data=subdat@data[,c("ZIPCODE","POPULATION")]
subdat.rownames=rownames(subdat_data)
subdat_data=
        subdat_data%>%left_join(avg_price_zip.df, by=c("ZIPCODE" = "region"))
rownames(subdat_data)=subdat.rownames

# ----- to write to geojson we need a SpatialPolygonsDataFrame
subdat<-SpatialPolygonsDataFrame(subdat, data=subdat_data[,c(1,3)])


# ----- subway count
subway<-read.csv("./data/subway_count.csv")
bus<-read.csv("./data/bus_count.csv")



