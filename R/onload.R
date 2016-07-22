.onLoad <- function(lib, pkg){
  if(identical("windows", .Platform$OS.type)){
    conf_path <- system.file("etc/ImageMagick-7", package = "magick")
    Sys.setenv(MAGICK_CONFIGURE_PATH = normalizePath(conf_path))
  }
  if(grepl("darwin", R.Version()$os, fixed = TRUE)){
    if(!nchar(Sys.getenv("FONTCONFIG_PATH"))){
      if(file.exists("/opt/X11/lib/X11/fontconfig")){
        #Sys.setenv(FONTCONFIG_PATH="/opt/X11/lib/X11/fontconfig")
      }
    }
  }
}
