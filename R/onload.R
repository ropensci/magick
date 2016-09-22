.onLoad <- function(lib, pkg){
  if(autobrewed()){
    Sys.setenv(FONTCONFIG_PATH=file.path(lib, pkg, "etc/fonts"))
  }
}
