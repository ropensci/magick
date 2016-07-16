.onLoad <- function(lib, pkg){
  if(identical("windows", .Platform$OS.type)){
    conf_path <- system.file("etc/ImageMagick-7", package = "magick")
    Sys.setenv(MAGICK_CONFIGURE_PATH = normalizePath(conf_path))
  }
}
