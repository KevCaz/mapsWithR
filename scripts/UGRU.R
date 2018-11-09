#### Packages ####
# read manipulate vector files tidyverse friendly
# introduce sf sfg and sfc objects
# rgeos
library(sf) # functions start with st_*
# read + manipulate raster files
library(raster)
# Visualize in a web browser
library(mapview)
# we already have a couple of nice tuto about it!
library(tidyverse)

#### Create a folder 'data'
dir.create("data")


#### First vector file ####
## in raster => function getData()
can <- getData("GADM", country = "CAN", level = 1, path = "data") %>% st_as_sf
class(can)
names(can)
##
ont <- can %>% filter(NAME_1 == "Ontario")
mapview(ont)
##
plot(ont)
plot(st_geometry(ont))
plot(st_geometry(ont) %>% st_simplify(dTolerance = .5))
## ggplot
## see https://ggplot2.tidyverse.org/reference/ggsf.html
## http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html
# see also ggmap https://github.com/dkahle/ggmap
ggplot(ont) +
  geom_sf(color = "gray10", fill = "#97d5e2")
# Side note: write and read vector files
# st_write(ont, "data/ont.shp")
# ont <- st_read("data/ont.shp")



#### Open data ####
# Open data ontario federal, for instance
# https://www.ontario.ca/search/data-catalogue
# http://www.agr.gc.ca/atlas/data_donnees/lcv/aafcLand_Use/tif/
# download https://www.ontario.ca/data/farmers-markets
download.file(
  "http://www.omafra.gov.on.ca/english/landuse/gis/shp/farmersmarkets.zip",
  destfile = "data/farmersmarkets.zip"
)
## unzip it
unzip("data/farmersmarkets.zip", exdir = "data")
farmkt <- st_read("data/farmersmarkets/farmersmarkets.shp")
## extract the file
mapview(farmkt)
# another example https://www.ontario.ca/data/provincially-licensed-meat-plants
st_read("data/meatprocessingplants/licensedmeatprocessingplants.shp") %>% mapview



#### Farmers' Market (FM) ####

names(farmkt)
farmkt %>% filter(grepl("Guelph", Market_Nam)) %>% mapview
idg <- grepl("Guelph", farmkt$Market_Nam)
farmkt_guelph <- farmkt[idg,]

## Challenge 1
## Next week Guelph's, so you're looking for the 5th closet FM
## Hint: one option is to use st_distance() see ?st_distance
#### Answer ####
{
farmkt$toGuelph <- st_distance(farmkt[idg, ], farmkt) %>% as.vector
farmkt %>% arrange(toGuelph)
}




#### Counties ####

## retrieve data
can <- getData("GADM", country = "CAN", level = 2, path = "data") %>% st_as_sf
ont2 <- can %>% filter(NAME_1 == "Ontario")
mapview(ont2)

## Challenge 2
## Now you are focusing on two counties: Waterloo and Wellington
## 1. create a new sf object with these two counties
## 2. combine them (see ?st_union)
## 3. What is the corresponding area?
## 4. How many FM in these two counties?
#### Answers ####
{
  wewa <- ont2 %>% filter(NAME_2 %in% c("Waterloo", "Wellington")) %>% st_union
  class(wewa)
  wewa <- ont2 %>% filter(NAME_2 %in% c("Waterloo", "Wellington")) %>% st_union %>% st_sf
  class(wewa)
  mapview(wewa)
  st_area(wewa)
  ##
  st_contains(wewa, farmkt) ## does not work
  ## check crs
  st_crs(farmkt)
  st_crs(wewa)
  ## so
  st_contains(wewa %>% st_transform(4269), farmkt)
  st_contains(wewa %>% st_transform(4269), farmkt)
  ## using an adequate projection
  id_fm <- st_contains(wewa %>% st_transform(3161), farmkt %>% st_transform(3161)) %>% unlist
  length(id_fm)
  mapview(farmkt[id_fm,]) + mapview(wewa)
}




#### Elevation ####
## NB coarse resolution
can_elv <- getData("alt", country = "CAN", path = "data")
## rasterize
system.time(
  ont_elv_nc <- rasterize(ont, can_elv, mask = TRUE)
)
## crop first
system.time(
  ont_elv <- rasterize(ont, crop(can_elv, ont), mask = TRUE)
)
##
projection(ont_elv)
## extract values from a raster file
val_elv <- raster::extract(can_elv, wewa) %>% unlist
hist(val_elv)


## Challenge 3
## 1. Draw the raster of elevation for wewa
## 2. Do a buffer of elevation of 10km around Guelph's FM and get the mean elevation
## 3. Find the county with the higest elevation on average
#### Answers ####
{
## 1
wewa_elv <- rasterize(wewa, crop(ont_elv, wewa), mask = TRUE)
## 2
gfm_buf <- st_buffer(farmkt[idg, ] %>% st_transform(3161), 5000)
mapview(gfm_buf) + mapview(wewa_elv)
buf_elv_val <- raster::extract(wewa_elv, st_transform(gfm_buf, 4326))
hist(unlist(buf_elv_val))
## 2
res_elv_mean <- raster::extract(ont_elv, ont2) %>% lapply(mean, na.rm = TRUE)
mapview(ont2[which.max(res_elv_mean),]) + mapview(ont_elv)
