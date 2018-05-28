#' Local Adaptive Thresholding
#'
#' Width x height define the size of the pixel neighborhood and offset
#' is a constant to subtract from pixel neighborhood mean.
#'
#' @export
#' @inheritParams editing
#' @param width size of the pixel neighborhood
#' @param height size of the pixel neighborhood
#' @param offset a constant to subtract from pixel neighborhood mean
image_treshold <- function(image, width, height, offset = 0){
  assert_image(image)
  magick_image_treshold(image, width, height, offset)
}
