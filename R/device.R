#' Magick Graphics Device
#'
#' Graphics device that produces a Magick image. Can either be used like a regular
#' device for making plots, or alternatively via \code{image_draw} to open a device
#' which draws onto an existing image using pixel coordinates.
#'
#' The device is a relatively recent feature of the package. It should support all
#' operations but there might still be small inaccuracies. Also it a bit slower than
#' some of the other devices, in particular for rendering text and clipping. Hopefully
#' this can be optimized in the next version.
#'
#' By default \code{image_draw} sets all margins to 0 and uses graphics coordinates to
#' match image size in pixels (width x height) where \code{(0,0)} is the top left corner.
#' Note that this means the y axis increases from top to bottom which is the opposite
#' of typical graphics coordinates.  You can override all this by passing custom
#' \code{xlim}, \code{ylim} or \code{mar} values to \code{image_draw}.
#'
#' @export
#' @rdname device
#' @name device
#' @param width in pixels
#' @param height in pixels
#' @param bg background color
#' @param pointsize size of fonts
#' @param res resolution in pixels
#' @param ... additional device parameters passed to \link{plot.window} such as
#' \code{xlim}, \code{ylim}, or \code{mar}.
#' @param clip enable clipping in the device. Because clippig can slow things down
#' a lot, you can disable it if you don't need it.
#' @examples # Regular image
#' frink <- image_read("https://jeroen.github.io/images/frink.png")
#'
#' # Produce image using graphics device
#' fig <- image_device(res = 96)
#' ggplot2::qplot(mpg, wt, data = mtcars, colour = cyl)
#' dev.off()
#'
#' # Combine
#' out <- image_composite(fig, frink, offset = "+70+30")
#' print(out)
#'
#' # Or paint over an existing image
#' img <- image_draw(frink)
#' rect(20, 20, 200, 100, border = "red", lty = "dashed", lwd = 5)
#' abline(h = 300, col = 'blue', lwd = '10', lty = "dotted")
#' text(10, 250, "Hoiven-Glaven", family = "courier", cex = 4, srt = 90)
#' palette(rainbow(11, end = 0.9))
#' symbols(rep(200, 11), seq(0, 400, 40), circles = runif(11, 5, 35),
#'   bg = 1:11, inches = FALSE, add = TRUE)
#' dev.off()
#' print(img)
image_device <- function(width = 800, height = 600, bg = "transparent",
                          pointsize = 12, res = 72, clip = TRUE) {
  img <- magick_device_internal(bg = bg, width = width, height = height, pointsize = pointsize,
                                res = res, clip = clip, multipage = TRUE)
  class(img) <- c("magick-device", class(img))
  img
}

#' @rdname device
#' @export
#' @param image an existing image on which to start drawing
image_draw <- function(image, pointsize = 12, res = 72, ...){
  assert_image(image)
  info <- image_info(utils::tail(image, 1))
  device <- magick_device_internal(bg = "transparent", width = info$width, height = info$height,
                                   pointsize = pointsize, res = res, clip = TRUE, multipage = FALSE)
  setup_device(info, ...)
  magick_image_replace(device, 1, image)
}

setup_device <- function(info, xlim = NULL, ylim = NULL, xaxs = "i", yaxs = "i", mar = c(0,0,0,0), ...){
  if(!length(xlim))
    xlim <- c(0, info$width)
  if(!length(ylim))
    ylim <- c(info$height, 0)
  graphics::plot.new()
  graphics::par(mar = mar)
  graphics::plot.window(xlim = xlim, ylim = ylim, xaxs = xaxs, yaxs = yaxs, ...)
}
