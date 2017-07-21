#' Magick Graphics Device
#'
#' Graphics device that produces a Magick image type.
#'
#' @export
#' @param width in pixels
#' @param height in pixels
#' @param bg background color
#' @param pointsize size of fonts
magick <- function(width = 1280, height = 720, bg = "transparent", pointsize = 12) {
  magick_(bg, width, height, pointsize)
}
