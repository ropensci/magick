#' Image Analysis
#'
#' Functions for performing calculation and statistics on images.
#'
#' @export
#' @family image
#' @rdname transformations
#' @inheritParams editing
#' @param reference_image another image to compare to
#' @param metric string with a
#' \href{http://www.imagemagick.org/script/command-line-options.php#metric}{metric type}
#' @examples
#' logo <- image_read("logo:")
#' logo2 <- image_blur(logo, 3)
#' logo3 <- image_oilpaint(logo, 3)
#' if(magick_config()$version >= "6.8.7"){
#'   image_compare(logo, logo2, metric = "phash")
#'   image_compare(logo, logo3, metric = "phash")
#' }
image_compare <- function(image, reference_image, metric = ""){
  metric <- as.character(metric)
  magick_image_compare(image, reference_image, metric)
}
