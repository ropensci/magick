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
#' @examples # Start a new graphics device
#' img <- magick_device()
#' example(rect)
#' dev.off()
#' print(img)
#'
#' # Or paint over an existing image
#' frink <- image_read("https://jeroen.github.io/images/frink.png")
#' device <- image_draw(frink)
#' abline(h = 100, col = 'green', lwd = '10')
#' abline(v = 100, col = 'red', lwd = '10', lty = 'dashed')
#' dev.off()
#' print(device)
magick_device <- function(width = 800, height = 600, bg = "transparent",
                          pointsize = 12, res = 72, clip = TRUE) {
  img <- magick_device_internal(bg, width, height, pointsize, res, clip)
  class(img) <- c("magick-device", class(img))
  img
}

#' @rdname device
#' @export
#' @param image an existing image on which to start drawing
image_draw <- function(image, pointsize = 12, res = 72){
  assert_image(image)
  info <- image_info(utils::tail(image, 1))
  device <- magick_device(width = info$width, height = info$height,
                            bg = "transparent", pointsize = pointsize, res = res)
  # Setup 'world' coordinates; taken from: getS3method('plot', 'raster')
  plot.new()
  par(mar = c(0,0,0,0))
  plot.window(xlim = c(0, info$width), ylim = c(0, info$height), xaxs = "i", yaxs = "i")

  #Load the existing image onto the graphics device
  magick_image_replace(device, 1, image)
}
