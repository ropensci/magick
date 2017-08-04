.onAttach <- function(lib, pkg){
  # Test for features
  testfor <- c("cairo", "fontconfig", "freetype", "fftw", "ghostscript", "lcms", "pango", "rsvg", "webp", "x11")
  support <- unlist(magick_config()[testfor])
  has <- paste(names(which(support)), collapse = ", ")
  not <- paste(names(which(!support)), collapse = ", ")

  packageStartupMessage(sprintf("Linking to ImageMagick %s\nEnabled features: %s\nDisabled features: %s",
                                as.character(magick_config()$version), has, not))
  if(magick_config()$version >= 7)
    packageStartupMessage(c("Attention: the 'magick' package has been compiled with ImageMagick-7 which is known to have problems.\n",
"Rebuilding against ImageMagick-6 is recommended."))

  # For RStudio
  autoviewer_enable()
}

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

