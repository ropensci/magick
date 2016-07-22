.onLoad <- function(lib, pkg){
  if(autobrewed()){
    if(!nchar(Sys.getenv("FONTCONFIG_PATH"))){
      if(file.exists("/opt/X11/lib/X11/fontconfig")){
        Sys.setenv(FONTCONFIG_PATH="/opt/X11/lib/X11/fontconfig")
      }
    }
  }
}
