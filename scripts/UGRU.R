# read manipulate vector files tidyverse friendly
library(sf) # functions starts with st_*
# read + manipulate raster files
library(raster)
# Visualize in a web browser
library(mapview)
#
library(tidyverse)

## in raster => function getData()
can <- getData("GADM", country = "CAN", level = 1, path = "data") %>% st_as_sf
ont <- can %>% filter(NAME_1 == "Ontario")
mapview(ont)


# https://www.r-spatial.org/r/2018/10/25/ggplot2-sf-3.html
# library(osmdata)
#
# q1 <- opq('Toronto') %>%
#     add_osm_feature(key = 'highway', value = 'cycleway')
# cway_sev <- osmdata_sp(q1)
# mapview(cway_sev$osm_lines)
