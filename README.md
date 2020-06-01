# GeoStatistical Image Fusion
* Image Fusion is the method for enhancing information content in the images.
* Using Image Fusion spectral quality of high spatial resolution images can be improved.
* Geostatistical techniques i.e. Cokriging and Regression Kriging have been used in this project to fuse images.

# Data Used in this project
* Landsat 8 Satellite images (acquired from USGS).

# Objective
* Fusion of Multispectral bands with Panchromatic band using Ordinary  Cokriging (COK) and Regression Kriging (RK).
* Spectral and Spatial Quality assessment of fused Images.

# Prerequisites
There are certain prerequirements that needs to be fulfilled. These are as follows: 
1. **R:** It is a programming laguage for statistics and graphics. It can be downloaded for free from [here](https://cran.r-project.org/)!
2. **GSTAT:** It is a package for R that can be used for "Spatial and Spatio-Temporal Geostatistical Modelling, Prediction and Simulation", and it can be downloaded either using "install.packages("gstat") command in R or directly from [here](https://cran.r-project.org/web/packages/gstat/index.html)!

# Methods 
 Co Kriging: 
 * In COK, the estimated variable h at any location (o) is a linear combination of input variables. 
 * In this project, two variables of interest are there: high spatial and high spectral resolution variable represented as h and l    respectively. 
 * The estimation of h (target variable) at location (o) using COK is given as follow (Memarsadeghi, Moigne, & Mount, 2006):<br/>
 ![](https://github.com/82siha1mpg/GeoStatisticalImageFusion/blob/master/Images/COK.png)
 
 Cokriging is carried in following three main steps:<br/>
    1. Describe the spatial variation in the sample data.<br/>
    2. Summarize the spatial variation by a mathematical function.<br/>
    3. Use this model to determine the interpolation weights.<br/>
 <br/>
 Regression Kriging
 RK is carried out in various steps which are described as follows:<br/>
  *  Regression of primary variable on auxiliary variable. <br/>
  *  Describe spatial variation in regression residuals. <br/>
  *  Generating an error surface by interpolating regression residuals. <br/>
  *  Adding trend surface and error surface to generate  final predictions.<br/>
  The estimated value of target variable at unsampled location using RK is given by (Hengl, Heuvelink, & Rossiter, 2007):
   ![](https://github.com/82siha1mpg/GeoStatisticalImageFusion/blob/master/Images/RK.png)

* To check these methods in more detail, please read the paper that I have published [here](https://doi.org/10.1007/s41324-018-00235-z)!

# Authors
* Harpreet Singh, harpreet19897079@gmail.com 
* Mr. Prabhakar Alok Verma, 

