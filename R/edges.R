#' Edge / Line Detection
#'
#' Tools to find edges and try to calculate lines.
#'
#' @export
#' @inheritParams editing
#' @rdname edges
#' @param geom geometry string `{W}x{H}+{threshold}` defining the size and threshold of
#' the filter used to find 'peaks' in the intermediate search image
#' @param size size in points to draw the line
#' @param bg background color
#' @param radius edge size in pixels
#' @param format output format of the text, either `svg` or `mvg`
#' @examples
#' shape <- image_read('http://www.imagemagick.org/Usage/transform/shape_rectangle.gif')
#' rectangle <- image_edge(shape)
#' rectangle %>% image_hough_draw('5x5+20')
#' rectangle %>% image_hough_txt(format = 'svg') %>% cat()
image_edge <- function(image, radius = 1){
  assert_image(image)
  magick_image_edge(image, radius)
}

#' @export
#' @rdname edges
image_hough_draw <- function(image, geom = "5x5+20", color = 'red', bg = 'black', size = 3){
  assert_image(image)
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
