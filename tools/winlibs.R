# Build against imagemagick static website.
if(!file.exists("../windows/imagemagick-7.0.2.4/include/ImageMagick-7/Magick++.h")){
  if(getRversion() < "3.3.0") setInternet2()
  download.file("https://github.com/rwinlib/imagemagick/archive/v7.0.2.4.zip", "lib.zip", quiet = TRUE)
  dir.create("../windows", showWarnings = FALSE)
  unzip("lib.zip", exdir = "../windows")
  unlink("lib.zip")
}
