if(!file.exists("base.o") && !file.exists("../.libs/imagemagick/include/ImageMagick-6/Magick++.h")){
  unlink("../.libs", recursive = TRUE)
  url <- if(grepl("aarch", R.version$platform)){
    "https://github.com/r-windows/bundles/releases/download/imagemagick-6.9.12.98/imagemagick-6.9.12.98-clang-aarch64.tar.xz"
  } else if(grepl("clang", Sys.getenv('R_COMPILED_BY'))){
    "https://github.com/r-windows/bundles/releases/download/imagemagick-6.9.12.98/imagemagick-6.9.12.98-clang-x86_64.tar.xz"
  } else if(getRversion() >= "4.3") {
    "https://github.com/r-windows/bundles/releases/download/imagemagick-6.9.12.98/imagemagick-6.9.12.98-ucrt-x86_64.tar.xz"
  } else {
    "https://github.com/rwinlib/imagemagick6/archive/v6.9.12-96.tar.gz"
  }
  options(timeout = 300)
  download.file(url, basename(url), quiet = TRUE)
  dir.create("../.libs", showWarnings = FALSE)
  untar(basename(url), exdir = "../.libs", tar = 'internal')
  unlink(basename(url))
  setwd("../.libs")
  file.rename(list.files(), 'imagemagick')
}
