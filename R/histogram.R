
#' image histogram
#'
#' @param image an image
#' @param height the height of each histogram in pixels
#' @return the result histograms
#' @export
#' @examples
#' cute_cat <- image_read("http://i.telegraph.co.uk/multimedia/archive/02830/cat_2830677b.jpg")
#' image_histogram(cute_cat)
image_histogram <- function(image, height = 100){
  assert_image(image)
  magick_image_histogram(image, height)
}
