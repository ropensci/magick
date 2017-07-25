#' Magick Graphics Device
#'
#' Graphics device that produces a Magick image type. Works like other graphics
#' devices but instead of writing to a file, the drawings get written to a magick
#' image object which can then be treated like any other image object.
#'
#' The device is a relatively recent feature of the package. It should support all
#' operations but there might still be small inaccuracies. Also it is currently a
#' bit slow, probably because it is rendering too frequently. Perhaps the next
#' version will use lazy rendering.
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
#' @examples img <- magick_device()
#' example(rect)
#' dev.off()
#' print(img)
magick_device <- function(width = 800, height = 600, bg = "transparent", pointsize = 12, clipping = FALSE) {
  img <- magick_(bg, width, height, pointsize, clipping)
  class(img) <- c("magick-device", class(img))
  img
}
