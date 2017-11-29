#' Geometry Helpers
#'
#' ImageMagick uses a special geometry syntax to specify coordinates and shapes.
#' You can simply specify these as strings but you can also use these functions
#' to construct them.
#'
#' See [ImageMagick Manual](http://www.imagemagick.org/Magick++/Geometry.html)
#' for syntax specification.
#'
#' @export
#' @rdname geometry
#' @name geometry
#' @references [ImageMagick Manual](http://www.imagemagick.org/Magick++/Geometry.html)
#' @param x left offset in pixels
#' @param y top offset in pixels
#' @examples coordinate(50, 80)
coordinate <- function(x, y){
  sprintf("%+d%+d", x, y)
}

#' @export
#' @rdname geometry
#' @param width in pixels
#' @param height in pixels
#' @param x_off offset in pixels on x axis
#' @param y_off offset in pixels on y axis
#' @param percent interpret width and height as a percentage of the current size.
#' @param preserve_aspect if FALSE, resize to width and height exactly, loosing original aspect ratio.
#' @examples geometry(100, 200)
#' geometry(100, 200, 10, 10)
geometry <- function(width, height, x_off = 0, y_off = 0, percent = FALSE, preserve_aspect = TRUE){
  pctstr <- ifelse(isTRUE(percent), "%", "")
  arstr <- ifelse(isTRUE(preserve_aspect), "", "!")
  if(!x_off && !y_off){
    sprintf("%dx%d%s%s", width, height, pctstr, arstr)
  } else {
    sprintf("%dx%d%+d%+d%s%s", width, height, x_off, y_off, pctstr, arstr)
  }
}
