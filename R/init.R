.onAttach <- function(lib, pkg){
  packageStartupMessage(sprintf("Linkging to ImageMagick %s", as.character(magick_config()$version)))
  if(magick_config()$version >= 7)
    packageStartupMessage(c("Attention: the 'magick' package has been compiled with ImageMagick-7 which is known to have problems.\n",
"Rebuilding against ImageMagick-6 is recommended."))
}
