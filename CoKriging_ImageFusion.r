####################
# CO-Kriging Script#
###################

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

#Set Working Directory
setwd('path to working directory')


#Reading Images (Spatial Grid Data Frame).
# @Band2 : Blue band of Landsat 8 
# @Band8 : Pan band of Landsat 8

mss<-readGDAL("band2.img")
pan<-readGDAL("band8.img")

#Displaying structure of Object created above. 
str(mss)
str(pan)


## Checking if the input data is normally distributed.
fit.norm <- fitdist(pan$band1, "norm")
plot(fit.norm)

#Spatially overlaying multispectral and panchromatics bands
# as they both have different grid size.
pan.over <- over(mss,pan)

#checking summary of new overlayed panchromatic vector of pixel values.
summary(pan.over)

#putting overlayed panchromatic band values to mss spatialGridDataFrame.
# mss$band2 corresponds to multispectral, whereas mss$band1 corresponds to panchromatic values.

mss$band2 <- mss$band1
mss$band1 <- NULL
mss$band1 <- pan.over$band1
summary(mss)

# Creating SemiVariogram and fitting model to the sampled data.

semVario.mss.locations <- gstat(id="mss", formula = mss$band2~1, data=mss)
semVario.mss.locations <- gstat(semVario.mss.locations, "pan", mss$band1~1, data=mss)
semVario.mss.locations <- gstat(semVario.mss.locations, model=vgm(350000,"Exp",2500,0), fill.all=T)
variogram.Model <- variogram(semVario.mss.locations, cutoff=7000, width=100, debug.level = -1)

#Plotting the variograms.
plot(variogram.Model)

#Fitting & plotting a Local model of coregionalisation.
co.fit <- fit.lmc(variogram.Model, semVario.mss.locations)
plot(variogram.Model , model = co.fit)
semVario.mss.locations <- co.fit

#creating semivariogram and fiting models to all panchromatic values.
semVario.pan.locations <- gstat(id="mss", formula = mss$band2~1, data=mss,nmax=32)
semVario.pan.locations <- gstat(semVario.pan.locations, "pan", pan$band1~1, data=pan,nmax=32)

semVario.pan.locations$model<-semVario.mss.locations$model
semVario.pan.locations.fit <- fit.lmc(variogram.Model, semVario.pan.locations)
semVario.pan.locations <- semVario.pan.locations.fit

#Making predictions using the model created above 'semVario.pan.locations'.

predictedSurface <- predict(semVario.pan.locations, newdata = pan , debug.level = -1)


#Converting SpatialGridDataFrame to Raster object.
fusedRaster <- raster(predictedSurface, "fusedRaster")

#Writing fused image as GeoTiff file for Raster Object created above.
writeRaster(fusedRaster, filename = "COK_B2_(32Neighbours)PRED", format = "GTiff")

#Writing variance in the predicted surface as GeoTiff file.
mss.var <- raster(predictedSurface, "mss.var")
writeRaster(mss.var, filename = "COK_Band2_(32Neighbours)Variance", format = "GTiff")

#********************END***********************#