
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
avg_price.df<-price[,c("region","avg")]%>%
        group_by(region)%>%
        summarise(
                value=mean(avg)
        )
save(avg_price.df, file="./output/avg_price.RData")


library(choroplethrZip)
zip_choropleth(avg_price.df,
               title       = "2017 Manhattan housing rental price",
               legend      = "Average price",
               county_zoom = 36061)

