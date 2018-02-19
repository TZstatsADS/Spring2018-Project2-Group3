rank_all <- read.csv("../data/rank_all.csv")
level_zip <- read.csv("../data/level_zip.csv")
load("../output/price.RData")

price1 <- price[,c("region","priceperroom","room","type")]
#rank_all <- merge(rank_all,price1,by.x = "zipcode",by.y = "region")

price2 <- data.frame(matrix(rep(NA,6*46),nrow = 46))
names(price2) <- c("zipcode","Studio","1B","2B","3B","4B")
price2$zipcode <- rank_all$zipcode


# library(dplyr)
# test <- price1 %>%
#   group_by(region) %>%
#   distinct(type) %>%
#   summarise(paste0(type))


#studio
p <- price1[price1$type == "Studio",]
for(i in 1:nrow(price2)){
  index <- which(price2$zipcode == p$region[i])
  price2[index,"Studio"] <- p$priceperroom[i] 
}
#1B
p <- price1[price1$type == "OneBedroom",]
for(i in 1:nrow(price2)){
  index <- which(price2$zipcode == p$region[i])
  price2[index,"1B"] <- p$priceperroom[i] 
}
#2B
p <- price1[price1$type == "TwoBedroom",]
for(i in 1:nrow(price2)){
  index <- which(price2$zipcode == p$region[i])
  price2[index,"2B"] <- p$priceperroom[i] 
}
#3B
p <- price1[price1$type == "ThreeBedroom",]
for(i in 1:nrow(price2)){
  index <- which(price2$zipcode == p$region[i])
  price2[index,"3B"] <- p$priceperroom[i] 
}
#4B
p <- price1[price1$type == "FourBedroom",]
for(i in 1:nrow(price2)){
  index <- which(price2$zipcode == p$region[i])
  price2[index,"4B"] <- p$priceperroom[i] 
}

rank_all <- cbind(rank_all,price2[,2:6])

write.csv(rank_all,"rank_all.csv")
  
  
  
