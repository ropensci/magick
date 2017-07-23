.onAttach <- function(lib, pkg){
  packageStartupMessage(sprintf("ImageMagick %s", as.character(magick_config()$version)))
  if(magick_config()$version >= 7)
    warning(c("This package has been compiled with ImageMagick-7 which is known to be buggy.\n",
"Rebuilding against ImageMagick-6 is recommended."), call. = FALSE, immediate. = TRUE)
}
