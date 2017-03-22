#' Capture the contents of the current graphics device as an image
#'
#' @param device The graphics device you wish to capture.  The graphics device
#' must be a bitmap device that supports raster capture, such as Quartz, X11,
#' or devices in the Cairo package. Cairo(type="raster") is suggested for
#' non-interactive applications where you wish to avoid any writing to disk.
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
#' image_flip(densimage)
#'
image_capture <- function(device=dev.cur()) {
  magick_image_readbitmap_device(device)
}
