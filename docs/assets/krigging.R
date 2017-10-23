##--- package
library(sp)
library(raster)
library(fields)


##--- mapOnt
bouCAN <- getData(country='CAN', level=1, path="./assets/")
mapOnt <- bouCAN[11, ]
bb <- bbox(mapOnt)

##--- data (simulated)
coord <- as.matrix(data.frame(
  x = runif(40, bb[1,1], bb[1,2]),
  y = runif(40, bb[2,1], bb[2,2])
))
val <- rnorm(40)
val[val<0] = 0
##--- Do the krigging
modk1 <- Krig(x = coord, Y = val, lambda = .5)
modk2 <- Krig(x = coord, Y = val, lambda = 5)
##--- quick plot
surface(modk1)
plot(mapOnt, add=T)
points(coord[,1], coord[,2], cex= val+1, pch=19)


##--- grid for predictions
resx = 160
resy = 200
seqx <- seq(bb[1,1], bb[1,2], length.out=resx)
seqy <- seq(bb[2,1], bb[2,2], length.out=resy)
grid <- as.matrix(expand.grid(seqx, rev(seqy)))

##--- Predictions
predk1 <- predict(modk1, x = grid)
predk2 <- predict(modk2, x = grid)
# plot(as.matrix(coord), predict.mKrig(modk, x = as.matrix(coord)))

##--- Turn predk into a raster
matk1 <- matrix(predk1, resy, resx, byrow=TRUE)
matk2 <- matrix(predk2, resy, resx, byrow=TRUE)
rastk1 <- rasterize(mapOnt, raster(matk1, crs=CRS(proj4string(mapOnt)), xmn=bb[1,1], xmx=bb[1,2], ymn=bb[2,1], ymx=bb[2,2]), mask=TRUE)
rastk2 <- rasterize(mapOnt, raster(matk2, crs=CRS(proj4string(mapOnt)), xmn=bb[1,1], xmx=bb[1,2], ymn=bb[2,1], ymx=bb[2,2]), mask=TRUE)



##--- plotquilt.plot( xCO, predict(out))
par(mfrow=c(1,3))
plot(rastk1, main = "theta = .5")
plot(mapOnt, add=T)
plot(rastk2, main = "theta = 5")
points(coord[,1], coord[,2], cex= val+.4, pch=19, col = 'grey40')
surface(modk1)
plot(mapOnt, add=T)
points(coord[,1], coord[,2], cex= val+.4, pch=19, col = 'grey40')
