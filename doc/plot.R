library(dplyr)
rank_all <- read.csv("../data/rank_all.csv")
rank_all$zipcode <- as.character(rank_all$zipcode)
#this is an example of zip
zip <- c("10025","10019")
zip_df <- filter(rank_all,zipcode %in% zip)

# par(mfrow = c(2,4))

#resturant
x <- zip_df %>% select("zipcode","count.Chinese","count.American","count.Italian","count.Japenses","count.Pizza","count.Others")
x <- melt(x,id.vars = "zipcode")
ggplot(x, aes(x=zipcode, y=value, fill=variable)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#D24136","#EFB509","#F0810F","#E29930","#EB8A3E","#EAB364"),labels = c("Chinese","American","Italian","Japenses","Pizza","Others"),name="Resturant") +
  xlab("\nZipcode") +
  ylab("Count\n") +
  theme_bw()

#market
x <- zip_df %>% select("zipcode","count.pharmacy","count.grocery")
x <- melt(x,id.vars = "zipcode")
ggplot(x, aes(x=zipcode, y=value, fill=variable)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#5C821A","#C6D166"),labels = c("Pharmacy","Geocery"),name="Market") +
  xlab("\nZipcode") +
  ylab("Count\n") +
  theme_bw()

#theatre
x <- zip_df %>% select("zipcode","count.movie","count.art")
x <- melt(x,id.vars = "zipcode")
ggplot(x, aes(x=zipcode, y=value, fill=variable)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#A1D6E2","#1995AD"),labels = c("Movie","Art"),name="Theatre") +
  xlab("\nZipcode") +
  ylab("Count\n") +
  theme_bw()

#crime
x <- zip_df %>% select("zipcode","rob.count","pet.count","har.count","gra.count","dan.count","as.count","oth.count")
x <- melt(x,id.vars = "zipcode")
ggplot(x, aes(x=zipcode, y=value, fill=variable)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#113743","#2C4A52","#537072","#8E9B97","#E4E3DB","#C5BEBA","#D6C6B9"),labels = c("ROBBERY","PETIT LARCENY","HARRASSMENT 2","GRAND LARCENY","DANGEROUS DRUGS","ASSAULT 3 & RELATED OFFENSES","Others"),name="Crime") +
  xlab("\nZipcode") +
  ylab("Count\n") +
  theme_bw()

#transportation
x <- zip_df %>% select("zipcode","count.bus","count.subway")
x <- melt(x,id.vars = "zipcode")
ggplot(x, aes(x=zipcode, y=value, fill=variable)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#CE5A57","#78A5A3"),labels = c("Bus","Subway"),name="Transportation") +
  xlab("\nZipcode") +
  ylab("Count\n") +
  theme_bw()





