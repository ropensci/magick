#' Capture the contents of the current graphics device as an image
#'
#' @param device The graphics device you wish to capture.  It must be a bitmap
#' device such as \code{\link[grDevices]{png}}, \code{\link[grDevices]{tiff}},
#' or \code{\link[Cairo]{CairoPNG}}. \code{\link[Cairo]{Cairo}(type="raster")}
#' is suggested for applications where you wish to avoid any writing to disk.
#'
#' @return
#' A magick image pointer
#' @export
#' @examples
#' library(Cairo)
#' Cairo(type="raster")
#' plot(density(rnorm(100)))
#' densimage <- image_capture()
#' dev.off()
#' densimage
image_capture <- function(device=dev.cur()) {
  if(names(device) == "Cairo") {
  native_bitmap <- Cairo::Cairo.capture(device)
  } else {
    if(device != dev.cur()) {
       mydev <- dev.cur()
       dev.set(device)
       on.exit(dev.set(mydev))
    }
    native_bitmap <- dev.capture(native=TRUE)
  }
  magick_image_readbitmap_nativeraster(native_bitmap)
}
