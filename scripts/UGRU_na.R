#### Packages ####
# read manipulate vector files tidyverse friendly
# intriduce sf sfg and sfc objects
library(sf) # functions starts with st_*
# read + manipulate raster files
library(raster)
# Visualize in a web browser
library(mapview)
# we already have a couple of nice tuto about it!
library(tidyverse)


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
plot(st_geometry)
plot(st_geometry(ont) %>% st_simplify(dTolerance = .01))
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
# Open data ontario & federal
# https://www.ontario.ca/search/data-catalogue
# https://www.ontario.ca/data/farmers-markets
# http://www.agr.gc.ca/atlas/data_donnees/lcv/aafcLand_Use/tif/
farmkt <- st_read("data/farmersmarkets/farmersmarkets.shp")
mapview(farmkt)
# another example https://www.ontario.ca/data/provincially-licensed-meat-plants
st_read("data/meatprocessingplants/licensedmeatprocessingplants.shp") %>% mapview



#### Farmers' Market (FM) ####

names(farmkt)
farmkt %>% filter(grepl("Guelph", Market_Nam))
idg <- grepl("Guelph", farmkt$Market_Nam)
farmkt_guelph <- farmkt[idg,]

## Challenge 1
## Next week Guelph's, so you're looking for the 5th closet FM
## Hint: one option is to use st_distance() see ?st_distance


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



#### Elevation ####
## NB coarse resoltion
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
val_elv <- extract(can_elv, wewa) %>% unlist
hist(val_elv)


## Challenge 3
## 1. Draw the raster of elevation for wewa
## 2. Do a buffer of elevation of 10km around Guelph's FM and get the mean elevation
## 3. Find the county with the higest elevation on average
#### Answers ####
