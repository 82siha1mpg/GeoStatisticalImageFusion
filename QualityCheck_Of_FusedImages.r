##################################
# Image Quality Index Calculation#
##################################

## This R program calculates image quality index for all three visible bands of landsat 8 image and comapres it with the fused image to 
## check if the quality of fused image is better than original image or not.
## Read more about this index:
## @ Wang, Z., & Bovik, A. C. (2002). A universal image quality index. IEEE Signal Processing Letters, 9(3), 81-84.


#*******************START**********************#

library(rgdal)

#Set Working Directory
#setwd('path to working directory')
setwd("C:\\Users\\Standard-User\\Desktop\\Practice")


image_quality <- function(orgBand , fusedBand){
  covxy = cov(orgBand$band1,fusedBand$band1, use="complete")
  meanx = mean(orgBand$band1)
  meany = mean(fusedBand$band1,na.rm = T)
  mx2 =  meanx*meanx # Square of mean x
  my2 =  meany*meany  # Square of mean y
  varx = var(orgBand$band1)
  vary = var(fusedBand$band1,na.rm = T)
  sigmax = var(orgBand$band1, use="complete")
  sigmay = var(fusedBand$band1, use="complete")
  
  return ((4*covxy*meanx*meany)/((varx+vary)*(mx2+my2)));
}



#Reading Images (Spatial Grid Data Frame).
# @fused2 : fused Image output for band 2 of Landsat 8 image
# @fused3 : fused Image output for band 3 of Landsat 8 image
# @fused4 : fused Image output for band 4 of Landsat 8 image
# @band2 : original band 2 of landsat 8, downscaled to 15 m resolution to match resolution of fused image.
# @band3 : original band 3 of landsat 8, downscaled to 15 m resolution to match resolution of fused image.
# @band4 : original band 4 of landsat 8, downscaled to 15 m resolution to match resolution of fused image.
# @band8 : original panchromatic band of landsat 8 image.

fused2 = readGDAL("COK_BAND2_PRED.tif")
#fused3 = readGDAL("COK_BAND3_PRED.tif")
#fused4 = readGDAL("COK_BAND4_PRED.tif")

band2 = readGDAL("band2_15m1.tif")
#band3 = readGDAL("band3_15m.tif")
#band4 = readGDAL("band4_15m.tif")
#band8 = readGDAL("band8.img")



qualityOutput = image_quality(band2,fused2)
print(qualityOutput)
