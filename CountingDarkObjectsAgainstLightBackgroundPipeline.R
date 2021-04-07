# Pipeline to count the number of objects against a dark background
# By J. M. A. Wojahn

# WARNING! This cannot detect overlapping objects as being distinct objects

# Depends on: "EBImage" and "raster"

#load packages
library(EBImage)
# read in your image
# this is a section from https://live.staticflickr.com/3721/13195855974_8ae468b547_b.jpg
# it is free to share and use according to its license
pix <- EBImage::readImage("MothingSheet.jpg")
# turn to grayscale
pix <- EBImage::channel(pix, mode = "gray")
# display
EBImage::display(pix)
# binaryize
pixcapped <- pix>0.8
# display, adjust value up or down if desired
EBImage::display(pixcapped)
# medianize
medianizedimage <- EBImage::medianFilter(pixcapped, size=1)
# display, adjust size up or down if desired
EBImage::display(medianizedimage)
#~~~ START OF OPTIONAL ~~~
# if your targets have holes of light color, then blur
medianizedimageblur <- EBImage::gblur(medianizedimage, sigma=0.5)
# display, adjust sigma up or down if desired
EBImage::display(medianizedimageblur)
# normalize
pixbwresnorm <-  EBImage::normalize(medianizedimageblur)
#~~~ END OF OPTIONAL ~~~
pixbwresnorm <-  EBImage::normalize(medianizedimage)
# display
EBImage::display(pixbwresnorm)
# binaryize
pixbwresnormcapped <- pixbwresnorm>0.8
# display, adjust value up or down if desired
EBImage::display(pixbwresnormcapped)
# Invert BW to WB
pixbwresnormcapped[which(pixbwresnormcapped[] == T)] <- NA
pixbwresnormcapped[which(!is.na(pixbwresnormcapped[]))] <- T
pixbwresnormcapped[which(is.na(pixbwresnormcapped[]))] <- F
#display
EBImage::display(pixbwresnormcapped)
# write out image
writeImage(pixbwresnormcapped,"processedpic.tif")
# read image in as raster
pixbwrast <- raster::raster("processedpic.tif")
# plot
raster::plot(pixbwrast)
# perform clumping
clumpedrast <- raster::clump(pixbwrast)
# plot
raster::plot(clumpedrast)
# count clumps
clumpedrastfreq <- as.data.frame(raster::freq(clumpedrast))
# report count of clumps
count_of_clumps <- length(which(!is.na(clumpedrastfreq[,1])))
print(count_of_clumps) 

# Copyright © 2020  John M. A. Wojahn

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
