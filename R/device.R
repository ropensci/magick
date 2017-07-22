#' Magick Graphics Device
#'
#' Graphics device that produces a Magick image type.
#'
#' @export
#' @param width in pixels
#' @param height in pixels
#' @param bg background color
#' @rdname device
#' @name device
#' @param pointsize size of fonts
magick_device <- function(width = 1280, height = 720, bg = "transparent", pointsize = 12) {
  img <- magick_(bg, width, height, pointsize)
  class(img) <- c("magick-device", class(img))
  img
}
