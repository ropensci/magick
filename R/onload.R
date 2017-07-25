.onLoad <- function(lib, pkg){
  if(autobrewed()){
    fontdir <- normalizePath(file.path(lib, pkg, "etc/fonts"), mustWork = FALSE)
    if(file.exists(fontdir)){
      Sys.setenv(FONTCONFIG_PATH = fontdir)
    } else if(file.exists("/opt/X11/lib/X11/fontconfig")){
      Sys.setenv(FONTCONFIG_PATH = "/opt/X11/lib/X11/fontconfig")
    }
  }
}
