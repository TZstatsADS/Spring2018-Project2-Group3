rank_all <- read.csv("../data/rank_all.csv")


#write a function to get a list of zipcode of 3 levels
getzip <- function(df){
  zip1 <- df$zipcode[1:19]
  zip2 <- df$zipcode[14:32]
  zip3 <- df$zipcode[28:46]
  return(as.data.frame(cbind(zip1,zip2,zip3)))
}


#transportation
rank_trans <- rank_all[,c("zipcode","ranking.trans")]
rank_trans <- rank_trans[order(rank_trans$ranking.trans),]
trans_zip <- getzip(rank_trans)
names(trans_zip) <- paste0("trans.",names(trans_zip))
#clubs
rank_club <- rank_all[,c("zipcode","ranking.bar")]
rank_club <- rank_club[order(rank_club$ranking.bar),]
club_zip <- getzip(rank_club)
names(club_zip) <- paste0("club.",names(club_zip))
#theatre
rank_theatre <- rank_all[,c("zipcode","ranking.theatre")]
rank_theatre <- rank_theatre[order(rank_theatre$ranking.theatre),]
theatre_zip <- getzip(rank_theatre)
names(theatre_zip) <- paste0("theatre.",names(theatre_zip))
#market
rank_market <- rank_all[,c("zipcode","ranking.market")]
rank_market <- rank_market[order(rank_market$ranking.market),]
market_zip <- getzip(rank_market)
names(market_zip) <- paste0("market.",names(market_zip))

level_zip <- c(trans_zip,club_zip,theatre_zip,market_zip)
#write.csv(level_zip,"level_zip.csv")







