load("../output/price.RData")
price$room <- rep(1,nrow(price))
price$room[price$type == "TwoBedroom"] <- 2
price$room[price$type == "ThreeBedroom"] <- 3
price$room[price$type == "FourBedroom"] <- 4
price$priceperroom <- round(price$avg/price$room,2)


save(price,file = "../output/price.RData")