name <- 
path <- paste0("../output/Resturant/resturant_location_", name, ".csv")
data <- read.csv(path)

library(ggmap)
library(dplyr)
loc1 <- data %>%
    mutate(ADDRESS = paste(BUILDING, STREET, "New York, NY", sep = ", ")) %>%
    mutate_geocode(ADDRESS)

path1 <- paste0("../output/Resturant/resturant_loc_", name, ".csv")
write.csv(loc1, file = path1)
