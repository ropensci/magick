.onAttach <- function(lib, pkg){
  # Test for features
  testfor <- c("cairo", "fontconfig", "freetype", "fftw", "ghostscript", "lcms", "pango", "rsvg", "webp", "x11")
  support <- unlist(magick_config()[testfor])
  has <- paste(names(which(support)), collapse = ", ")
  not <- paste(names(which(!support)), collapse = ", ")

  packageStartupMessage(sprintf("Linking to ImageMagick %s\nEnabled features: %s\nDisabled features: %s",
                                as.character(magick_config()$version), has, not))

  # For RStudio
  autoviewer_enable()
}

.onLoad <- function(lib, pkg){
  # Set tempdir to R session
  set_magick_tempdir(tempdir())

  # Needed by older versions of IM:
  Sys.setenv(MAGICK_TMPDIR = tempdir())

  # Set the default viewer
  if(is.null(getOption('magick.viewer'))){
    fun <- function(x){}
    body(fun) <- parse(text = 'magick:::image_preview(x)')
    environment(fun) <- baseenv()
    options(magick.viewer = fun)
  }

  # NB: it is needed that autobrew fontconfig is newer than xQuarts
  # or at least new enough to read the fontconfig data from the xQuarts fontconfig
  if(autobrewed()){
    fontdir <- normalizePath(file.path(lib, pkg, "etc/fontconfig"), mustWork = FALSE)
    if(file.exists("/opt/X11/lib/X11/fontconfig")){
      Sys.setenv(FONTCONFIG_PATH = "/opt/X11/lib/X11/fontconfig")
    } else if(file.exists(fontdir)){
      Sys.setenv(FONTCONFIG_PATH = fontdir)
    }
  } else if(is_mac()){
    # Workaround for R's built-in OpenMP conflicts
    # https://github.com/ropensci/magick/issues/170
    Sys.setenv(KMP_DUPLICATE_LIB_OK = 'TRUE')
  }
  register_s3_method("knitr", "knit_print", "magick-image")
}

register_s3_method <- function(pkg, generic, class, fun = NULL) {
  stopifnot(is.character(pkg), length(pkg) == 1)
  stopifnot(is.character(generic), length(generic) == 1)
  stopifnot(is.character(class), length(class) == 1)

  if (is.null(fun)) {
    fun <- get(paste0(generic, ".", class), envir = parent.frame())
  } else {
    stopifnot(is.function(fun))
  }

  if (pkg %in% loadedNamespaces()) {
    registerS3method(generic, class, fun, envir = asNamespace(pkg))
  }

  # Always register hook in case package is later unloaded & reloaded
  setHook(
    packageEvent(pkg, "onLoad"),
    function(...) {
      registerS3method(generic, class, fun, envir = asNamespace(pkg))
    }
  )
}

is_mac <- function(){
  grepl("darwin", R.Version()$platform)
}

