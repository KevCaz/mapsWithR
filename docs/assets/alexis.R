## @knitr read_data
tmp <- read.csv('assets/Feuil2.csv')
head(tmp)
## @knitr end_read_data

## @knitr make_sp
alex <- SpatialPointsDataFrame(
  tmp[c('lon', 'lat')],
  data = tmp[c('plot', 'elev')],
  proj4string = CRS('+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')
)
head(alex)
## @knitr end_make_sp

## @knitr plot_1
plot(alex)
## @knitr end_plot_1

## @knitr plot_2
mapview(alex)
## @knitr end_plot_2

## @knitr get_data
coord <- coordinates(alex)
# altCAN2 <- raster::getData(name="SRTM", lon = coord[1,1], lat = coord[1,2], path="assets/")
altCAN <- raster::getData(name="alt", country = "CAN", path="assets/")
bouCAN2 <- raster::getData(country='CAN', level=2, path="assets/")
bouCAN2_Q <- bouCAN2[bouCAN2@data$NAME_1 == "Québec",]
## @knitr end_get_data

## @knitr plot_3
par(mar=rep(0,4))
plot(bouCAN2_Q)
## @knitr end_plot_3

## @knitr over
al_ov <- over(alex, bouCAN2_Q)
head(al_ov)
## @knitr end_over

## @knitr region
id <- bouCAN2_Q@data$NAME_2 %in% al_ov$NAME_2
bouCAN2_Q@data$NAME_2[id]
## @knitr end_region

## @knitr plot_3b
par(mar=rep(0,4))
plot(bouCAN2_Q, lwd=.4)
plot(bouCAN2_Q[id,], add=T, border = NA, col = 2)
## @knitr end_plot_3b


## @knitr ra_elv
ra_elv <- rasterize(bouCAN2_Q[id,], crop(altCAN, bouCAN2_Q[id,]@bbox), mask=TRUE)
ra_elv
## @knitr end_ra_elv


## @knitr plot_4
par(mar=rep(0,4))
plot(ra_elv)
contour(ra_elv, add=T)
## @knitr end_plot_4


# plot(ra_elv2)
# plot(bouCAN2_Q[id,])
# plot(alex, add = T)
# plot(bouCAN2[bouCAN2@data$NAME_1 == "Québec",])


## @knitr buffer
buf <- gBuffer(alex, FALSE, width = .001)
buf
## @knitr end_buffer

## @knitr plot_5
plot(buf, col ="grey50")
plot(alex, add = TRUE, pch=20, col="grey20")
## @knitr end_plot_5

#
# plot(ra_elv2, add=T)
# plot(ra_elv, add=T)
# plot(alex, add = TRUE, pch=20, col="grey20")


## @knitr new_data
altCAN2 <- raster('assets/srtm_22_03.tif')
ra_elv2 <- rasterize(bouCAN2_Q[id,], crop(altCAN2, bouCAN2_Q[id,]@bbox), mask = TRUE)
alex@data$totalC <- runif(nrow(alex@data), 5, 50)
alex@data$categ <- rep(1:3, 10)
alex@data$elv2 <- extract(ra_elv, alex)
alex@data$elv3 <- extract(ra_elv2, alex)
head(alex@data)
# @knitr end_new_data


# alex@data$elv3 <- extract(ra_elv2, alex)

## @knitr plot_6
par(las=1)
palette(c('#c17abb', '#38e2d2', '#dadd65'))
plot(t(alex@bbox), type = 'n')
plot(alex, add=T, cex = log(alex@data$totalC), pch = 19, col = alex@data$categ)
## @knitr end_plot_6
