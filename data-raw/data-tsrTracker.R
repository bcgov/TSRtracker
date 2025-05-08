## code to prepare `data.tsrTracker` dataset goes here
library(bcdata)
library(sf)
tfl<-bcdata::bcdc_get_data("454f2153-efbd-4a6e-8966-a6d9755da9a6")
tfl$aoi<-tfl$FOREST_FILE_ID
tfl<-tfl["aoi"]
tfl$type <- "TFL"
tsa<-bcdata::bcdc_get_data("8daa29da-d7f4-401c-83ae-d962e3a28980")
tsa$aoi<-tsa$TSA_NUMBER_DESCRIPTION
tsa<-tsa["aoi"]
tsa$type <- "TSA"

data.tsrTracker<-rbind(tfl, tsa)

library(dplyr)
data.tsrTracker<-data.tsrTracker %>%
  group_by(aoi, type) %>%
  summarize(geometry = st_union(geometry))

#remove projection
data.tsrTracker <- sf::st_transform(data.tsrTracker, crs = 4326)

#append
usethis::use_data(data.tsrTracker, overwrite = TRUE)

geojson.tsrTracker<-rmapshaper::ms_simplify(geojsonsf::sf_geojson(data.tsrTracker))
usethis::use_data(geojson.tsrTracker, overwrite = TRUE)

