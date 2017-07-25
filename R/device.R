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
#' @param res resolution in pixels
#' @param clip enable clipping in the device. Because clippig can slow things down
#' a lot, you can disable it if you don't need it.
#' @examples img <- magick_device()
#' example(rect)
#' dev.off()
#' print(img)
magick_device <- function(width = 800, height = 600, bg = "transparent",
                          pointsize = 12, res = 72, clip = TRUE) {
  img <- magick_(bg, width, height, pointsize, res, clip)
  class(img) <- c("magick-device", class(img))
  img
}
