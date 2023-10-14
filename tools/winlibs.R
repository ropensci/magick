if(!file.exists("../windows/imagemagick/include/ImageMagick-6/Magick++.h")){
  unlink("../windows", recursive = TRUE)
  url <- if(grepl("aarch", R.version$platform)){
    "https://github.com/r-windows/bundles/releases/download/imagemagick-6.9.12.98/imagemagick-6.9.12.98-clang-aarch64.tar.xz"
  } else if(grepl("clang", Sys.getenv('R_COMPILED_BY'))){
    "https://github.com/r-windows/bundles/releases/download/imagemagick-6.9.12.98/imagemagick-6.9.12.98-clang-x86_64.tar.xz"
  } else if(getRversion() >= "4.3") {
    "https://github.com/r-windows/bundles/releases/download/imagemagick-6.9.12.98/imagemagick-6.9.12.98-ucrt-x86_64.tar.xz"
  } else {
    "https://github.com/rwinlib/imagemagick6/archive/v6.9.12-96.tar.gz"
  }
  download.file(url, basename(url), quiet = TRUE)
  dir.create("../windows", showWarnings = FALSE)
  untar(basename(url), exdir = "../windows", tar = 'internal')
  unlink(basename(url))
  setwd("../windows")
  file.rename(list.files(), 'imagemagick')
}
