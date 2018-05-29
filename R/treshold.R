#' Local Adaptive Thresholding
#'
#' Width x height define the size of the pixel neighborhood and offset
#' is a constant to subtract from pixel neighborhood mean.
#'
#' @export
#' @inheritParams editing
#' @param geometry pixel window plus offset for LAT algorithm
image_treshold <- function(image, geometry = '5x5+2%'){
  assert_image(image)
  magick_image_treshold(image, geometry)
}
