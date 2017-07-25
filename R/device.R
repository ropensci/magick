#' Magick Graphics Device
#'
#' Graphics device that produces a Magick image type.
#'
#' @export
#' @rdname device
#' @name device
#' @param width in pixels
#' @param height in pixels
#' @param bg background color
#' @param pointsize size of fonts
#' @param clipping enable clipping support. This id currently disabled by default because
#' it slows things down a lot
magick_device <- function(width = 1280, height = 720, bg = "transparent", pointsize = 12, clipping = FALSE) {
  img <- magick_(bg, width, height, pointsize, clipping)
  class(img) <- c("magick-device", class(img))
  img
}
