#' Edge / Line Detection
#'
#' Best results are obtained by finding edges with [image_canny()] and
#' then performing Hough-line detection on the edge image.
#'
#' For Hough-line detection, the geometry format is `{W}x{H}+{threshold}`
#' defining the size and threshold of the filter used to find 'peaks' in
#' the intermediate search image. For canny edge detection the format is
#' `{radius}x{sigma}+{lower%}+{upper%}`. More details and examples are
#' available at the [imagemagick website](https://legacy.imagemagick.org/Usage/transform/).
#'
#' @export
#' @inheritParams editing
#' @rdname edges
#' @name edges
#' @family image
#' @param geometry geometry string, see details.
#' @param bg background color
#' @param radius edge size in pixels
#' @param format output format of the text, either `svg` or `mvg`
#' @param size size in points to draw the line
#' @examples if(magick_config()$version > "6.8.9"){
#' shape <- demo_image("shape_rectangle.gif")
#' rectangle <- image_canny(shape)
#' rectangle %>% image_hough_draw('5x5+20')
#' rectangle %>% image_hough_txt(format = 'svg') %>% cat()
#' }
image_edge <- function(image, radius = 1){
  assert_image(image)
  radius <- as.numeric(radius)
  magick_image_edge(image, radius)
}

#' @export
#' @rdname edges
image_canny <- function(image, geometry = '0x1+10%+30%'){
  assert_image(image)
  geometry <- as.character(geometry)
  magick_image_canny(image, geometry)
}

#' @export
#' @rdname edges
#' @param overlay composite the drawing atop the input image. Only for `bg = 'transparent'`.
image_hough_draw <- function(image, geometry = NULL, color = 'red',
                             bg = 'transparent', size = 3, overlay = FALSE){
  assert_image(image)
  geometry <- as.character(geometry)
  if(!length(geometry)){
    info <- image_info(image)
    w <- ceiling(info$width * 0.05)
    h <- ceiling(info$height * 0.05)
    tres <- ceiling(min(info$width, info$height) * 0.20)
    geometry <- sprintf('%dx%d+%d', w, h, tres)
  }
  color <- as.character(color)
  bg <- as.character(bg)
  size <- as.numeric(size)
  out <- magick_image_houghline(image, geometry, color, bg, size)
  if(isTRUE(overlay))
    out <- image_composite(image, out)
  out
}

#' @export
#' @rdname edges
image_hough_txt <- function(image, geometry = NULL, format = c("mvg", "svg")){
  format <- match.arg(format)
  out <- image_hough_draw(image, geometry = geometry)
  rawToChar(image_write(out, format = format))
}
