############################
# Regression-Kriging Script#
############################

## This R program fuses panchromatic band with multispectral bands.
## In the following code, band2 is shown, and the same code has to be 
## run with band 3 and band 4 as well. The individual fused bands can
## then be merged at the end to produce Natural color composite of fused images.


#*******************START**********************#

# Load required packages

library(sp)
library(gstat)
library(raster)
library(rgdal)
library(fitdistrplus)

#Set Working Directory
setwd('path to working directory')

#Reading Images (Spatial Grid Data Frame).
# @Band2 : Blue band of Landsat 8 
# @Band8 : Pan band of Landsat 8
mss <- readGDAL("band2.img")
pan <- readGDAL("band8.img")

#Displaying structure of Object created above. 
str(mss)
str(pan)


## Checking if the input data is normally distributed.
fit.norm <- fitdist(mss$band1, "norm")
plot(fit.norm)



#Spatially overlaying multispectral and panchromatics bands
# as they both have different grid size.

pan.ov <- over(mss, pan)   #create grid-points overlay


#putting overlayed panchromatic band values to mss spatialGridDataFrame.
# mss$band2 corresponds to multispectral, whereas mss$band1 corresponds to panchromatic values.

mss$band2 <- mss$band1
mss$band1 <- NULL
mss$band1 <- pan.ov$band1   #copy the pan values

#fits regression model on sampled data and checking its summary.
lm.mss <- lm(band2~band1, mss)
summary(lm.mss)

#Plotting scatter plot and drawing regression model line onto that plot, to get overview of accuracy of model and checking error residuals.
plot(band2~band1,as.data.frame(mss), xlab="Pan Band 8", ylab=" Mss Band 2")
abline(lm(band2~band1, as.data.frame(mss)))



##. Estimate the residuals and their autocorrelation structure (variogram):
x.vario<-variogram(band2~band1, data=mss , debug.level=-1)
null.vgm <- vgm(var(mss$band2), "Sph", sqrt(areaSpatialGrid(pan))/4, nugget=0) # initial parameters
vgm_mss_r <- fit.variogram(x.vario, model=null.vgm)

#plotting the model.
plot(x.vario, vgm_mss_r, main="band2~Pan fitted by gstat")

# regression kriging on sampled data only! (Trend Surface)
mss_rk <- krige(band2~band1, locations=mss, newdata=pan, debug.level=-1)  

# Ordinary Kriging of residuals (Error Surface)
mss_rok <- krige(residuals(lm.mss)~1, locations=mss, newdata=pan, model=vgm_mss_r, nmax=200, debug.level=-1)

#Adding trend surface and error surface to generate  final predictions.
mss_rk$var1.rk <- mss_rk$var1.pred + mss_rok$var1.pred


#Converting SpatialGridDataFrame to Raster object.
#Writing fused image as GeoTiff file for Raster Object created above.
mss.pred = raster(mss_rk, "var1.rk")
writeRaster(mss.pred, filename = "Rk_Pred_band3", format = "GTiff")

#Writing variance in the predicted surface as GeoTiff file.
mss.var = raster(mss_rk, "var1.var")
writeRaster(mss.var, filename = "Rk_Band3_Variance", format = "GTiff")

#********************END***********************#

