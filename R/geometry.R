#' Geometry Helpers
#'
#' ImageMagick uses a handy geometry syntax to specify coordinates and shapes
#' for use in image transformations. You can either specify these manually as
#' strings or use the helper functions below.
#'
#' See [ImageMagick Manual](http://www.imagemagick.org/Magick++/Geometry.html)
#' for details about the syntax specification.
#' Examples of `geometry` strings:
#'  - __`"500x300"`__       -- *Resize image keeping aspect ratio, such that width does not exceed 500 and the height does not exceed 300.*
#'  - __`"500x300!"`__      -- *Resize image to 500 by 300, ignoring aspect ratio*
#'  - __`"500x"`__          -- *Resize width to 500 keep aspect ratio*
#'  - __`"x300"`__          -- *Resize height to 300 keep aspect ratio*
#'  - __\code{"50\%x20\%"}__ -- *Resize width to 50 percent and height to 20 percent of original*
#'  - __`"500x300+10+20"`__ -- *Crop image to 500 by 300 at position 10,20*
#'
#' @export
#' @family image
#' @rdname geometry
#' @name geometry
#' @param x left offset in pixels
#' @param y top offset in pixels
#' @param width in pixels
#' @param height in pixels
#' @param x_off offset in pixels on x axis
#' @param y_off offset in pixels on y axis
#' @param preserve_aspect if FALSE, resize to width and height exactly, loosing original
#' aspect ratio. Only one of `percent` and `preserve_aspect` may be `TRUE`.
#' @examples # Specify a point
#' logo <- image_read("logo:")
#' image_annotate(logo, "Some text", location = geometry_point(100, 200), size = 24)
#'
geometry_point <- function(x, y){
  sprintf("%+d%+d", as.integer(x), as.integer(y))
}

#' @export
#' @rdname geometry
#' @examples # Specify image area
#' image_crop(logo, geometry_area(300, 300), repage = FALSE)
#' image_crop(logo, geometry_area(300, 300, 100, 100), repage = FALSE)
#'
geometry_area <- function(width = NULL, height = NULL, x_off = 0, y_off = 0){
  wstr <- sprintf("%d", as.integer(width))
  hstr <- sprintf("x%d", as.integer(height))
  offstr <- if(x_off || y_off)
    geometry_point(x_off, y_off)
  paste0(wstr, hstr, offstr)
}

#' @export
#' @rdname geometry
#' @examples # Specify image size
#' image_resize(logo, geometry_size_pixels(300))
#' image_resize(logo, geometry_size_pixels(height = 300))
#' image_resize(logo, geometry_size_pixels(300, 300, preserve_aspect = FALSE))
#'
geometry_size_pixels <- function(width = NULL, height = NULL, preserve_aspect = TRUE){
  if(!length(width) && !length(height))
    stop("Either 'width' or 'height' must be set")
  wstr <- sprintf("%d", as.integer(width))
  hstr <- sprintf("x%d", as.integer(height))
  arstr <- if(!isTRUE(preserve_aspect)) "!"
  paste0(wstr, hstr, arstr)
}

#' @export
#' @rdname geometry
#' @examples # resize relative to current size
#' image_resize(logo, geometry_size_percent(50))
#' image_resize(logo, geometry_size_percent(50, 20))
#'
geometry_size_percent <- function(width = 100, height = NULL){
  if(width == height || !length(height)){
    paste0(width, "%")
  } else {
    paste0(width, "x", height, "%")
  }
}
