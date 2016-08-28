# Build against imagemagick static website.
IM_VERSION <- commandArgs(TRUE)
if(!file.exists("../windows/imagemagick6-6.9.5-4/include/ImageMagick-6/Magick++.h")){
  if(getRversion() < "3.3.0") setInternet2()
  download.file("https://github.com/rwinlib/imagemagick6/archive/v6.9.5-4.zip", "lib.zip", quiet = TRUE)
  dir.create("../windows", showWarnings = FALSE)
  unzip("lib.zip", exdir = "../windows")
  unlink("lib.zip")
}
