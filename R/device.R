#' Magick Graphics Device
#'
#' Graphics device that produces a Magick image. Can either be used like a regular
#' device for making plots, or alternatively via \code{image_draw} to open a device
#' which draws onto an existing image using pixel coordinates. The latter is vectorized,
#' i.e. drawing operations are applied to each frame in the image.
#'
#' The device is a relatively recent feature of the package. It should support all
#' operations but there might still be small inaccuracies. Also it is a bit slower than
#' some of the other devices, in particular for rendering text and clipping. Hopefully
#' this can be optimized in the next version.
#'
#' By default \code{image_draw} sets all margins to 0 and uses graphics coordinates to
#' match image size in pixels (width x height) where \code{(0,0)} is the top left corner.
#' Note that this means the y axis increases from top to bottom which is the opposite
#' of typical graphics coordinates.  You can override all this by passing custom
#' \code{xlim}, \code{ylim} or \code{mar} values to \code{image_draw}.
#'
#' The \code{image_capture} function returns the current device as an image. This only
#' works if the current device is a magick device or supports \link{dev.capture}.
#'
#' @export
#' @aliases image_device
#' @family image
#' @rdname device
#' @name device
#' @param width in pixels
#' @param height in pixels
#' @param bg background color
#' @param pointsize size of fonts
#' @param res resolution in pixels
#' @param clip enable clipping in the device. Because clipping can slow things down
#' a lot, you can disable it if you don't need it.
#' @param antialias TRUE/FALSE: enables anti-aliasing for text and strokes
#' @param ... additional device parameters passed to \link{plot.window} such as
#' \code{xlim}, \code{ylim}, or \code{mar}.
#' @examples # Regular image
#' frink <- image_read("https://jeroen.github.io/images/frink.png")
#'
#' # Produce image using graphics device
#' fig <- image_graph(res = 96)
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
#' text(10, 250, "Hoiven-Glaven", family = "monospace", cex = 4, srt = 90)
#' palette(rainbow(11, end = 0.9))
#' symbols(rep(200, 11), seq(0, 400, 40), circles = runif(11, 5, 35),
#'   bg = 1:11, inches = FALSE, add = TRUE)
#' dev.off()
#' print(img)
#'
#' \donttest{
#' # Vectorized example with custom coordinates
#' earth <- image_read("https://jeroen.github.io/images/earth.gif")
#' img <- image_draw(earth, xlim = c(0,1), ylim = c(0,1))
#' rect(.1, .1, .9, .9, border = "red", lty = "dashed", lwd = 5)
#' text(.5, .9, "Our planet", cex = 3, col = "white")
#' dev.off()
#' print(img)
#' }
image_graph <- function(width = 800, height = 600, bg = "white", pointsize = 12, res = 72,
                        clip = TRUE, antialias = TRUE) {
  img <- magick_device_internal(bg = bg, width = width, height = height, pointsize = pointsize,
                                res = res, clip = clip, antialias = antialias, drawing = FALSE)
  class(img) <- c("magick-device", class(img))
  img
}

#' @export
image_device <- image_graph

#' @rdname device
#' @export
#' @param image an existing image on which to start drawing
image_draw <- function(image, pointsize = 12, res = 72, antialias = TRUE, ...){
  assert_image(image)
  width <- max(image_info(image)$width)
  height <- max(image_info(image)$height)
  antialias <- as.logical(antialias)
  device <- magick_device_internal(bg = "transparent", width = width, height = height, pointsize = pointsize,
                                   res = res, clip = TRUE, antialias = antialias, drawing = TRUE)
  setup_device(list(width = width, height = height), ...)
  magick_image_copy(device, image)
  magick_attr_text_antialias(device, antialias)
  magick_attr_stroke_antialias(device, antialias)
  return(device)
}

#' @export
#' @rdname device
image_capture <- function(){
  which <- grDevices::dev.cur()
  if(which < 2)
    stop("No current open device")
  if(identical(names(which), "magick")){
    magick_device_get(which)
  } else {
    capt <- grDevices::dev.capture(TRUE)
    if(!is.matrix(capt))
      stop("Current device cannot be captured")
    image_read(capt)
  }
}

setup_device <- function(info, xlim = NULL, ylim = NULL, xaxs = "i", yaxs = "i", mar = c(0,0,0,0), ...){
  if(!length(xlim))
    xlim <- c(0, info$width)
  if(!length(ylim))
    ylim <- c(info$height, 0)
  graphics::par(mar = mar)
  graphics::plot.new()
  graphics::plot.window(xlim = xlim, ylim = ylim, xaxs = xaxs, yaxs = yaxs, ...)
}
