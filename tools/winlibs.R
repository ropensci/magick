# Build against imagemagick static website.
VERSION <- commandArgs(TRUE)
IM <- substr(VERSION, 1,1)
if(!file.exists(sprintf("../windows/imagemagick%s-%s/include/ImageMagick-%s/Magick++.h", IM, VERSION, IM))){
  if(getRversion() < "3.3.0") setInternet2()
  curl::curl_download(sprintf("https://github.com/rwinlib/imagemagick%s/archive/v%s.zip", IM, VERSION), "lib.zip")
  dir.create("../windows", showWarnings = FALSE)
  unzip("lib.zip", exdir = "../windows")
  unlink("lib.zip")
}
