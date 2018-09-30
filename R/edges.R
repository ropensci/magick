#' Edge / Line Detection
#'
#' Tools to find edges and try to calculate lines.
#'
#' For Hough-line detection, the geometry format is `{W}x{H}+{threshold}`
#' defining the size and threshold of the filter used to find 'peaks' in
#' the intermediate search image. For canny edge detection the format is
#' `{radius}x{sigma}+{lower%}+{upper%}`. More details and examples are
#' available at the [imagemagick website](https://www.imagemagick.org/Usage/transform).
#'
#' @export
#' @inheritParams editing
#' @rdname edges
#' @param geom geometry string, see details.
#' @param bg background color
#' @param radius edge size in pixels
#' @param format output format of the text, either `svg` or `mvg`
#' @param size size in points to draw the line
#' @examples
#' shape <- image_read('http://www.imagemagick.org/Usage/transform/shape_rectangle.gif')
#' rectangle <- image_canny(shape)
#' rectangle %>% image_hough_draw('5x5+20')
#' rectangle %>% image_hough_txt(format = 'svg') %>% cat()
image_edge <- function(image, radius = 1){
  assert_image(image)
  radius <- as.numeric(radius)
  magick_image_edge(image, radius)
}

#' @export
#' @rdname edges
image_canny <- function(image, geom = '0x1+10%+30%'){
  assert_image(image)
  geom <- as.character(geom)
  magick_image_canny(image, geom)
}

#' @export
#' @rdname edges
image_hough_draw <- function(image, geom = "5x5+20", color = 'red', bg = 'black', size = 3){
  assert_image(image)
  geom <- as.character(geom)
  color <- as.character(color)
  bg <- as.character(bg)
  size <- as.numeric(size)
  magick_image_houghline(image, geom, color, bg, size)
}

#' @export
#' @rdname edges
image_hough_txt <- function(image, geom = "5x5+20", format = c("mvg", "svg")){
  format <- match.arg(format)
  out <- image_hough_draw(image, geom = geom)
  rawToChar(image_write(out, format = format))
}
