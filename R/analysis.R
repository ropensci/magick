#' Image Analysis
#'
#' Functions for image calculations and analysis. This part of the package needs more work.
#'
#' For details see [Image++](https://www.imagemagick.org/Magick++/Image++.html)
#' documentation. Short descriptions:
#'
#'  - [image_compare] calculates a metric by comparing image with a reference image.
#'  - [image_fft] returns Discrete Fourier Transform (DFT) of the image as a
#'  magnitude / phase image pair. I wish I knew what this means.
#'
#' Here `image_compare()` is vectorized over the first argument and returns the diff image
#' with the calculated distortion value as an attribute.
#'
#' @export
#' @family image
#' @name analysis
#' @rdname analysis
#' @inheritParams editing
#' @inheritParams painting
#' @param reference_image another image to compare to
#' @param metric string with a [metric](http://www.imagemagick.org/script/command-line-options.php#metric)
#' from [metric_types()][metric_types] such as `"AE"` or `"phash"`
#' @examples
#' out1 <- image_blur(logo, 3)
#' out2 <- image_oilpaint(logo, 3)
#' input <- c(logo, out1, out2, logo)
#' if(magick_config()$version >= "6.8.7"){
#'   diff_img <- image_compare(input, logo, metric = "AE")
#'   attributes(diff_img)
#' }
image_compare <- function(image, reference_image, metric = "", fuzz = 0){
  metric <- as.character(metric)
  magick_image_compare(image, reference_image, metric, fuzz)
}

#' @rdname analysis
#' @export
image_compare_dist <- function(image, reference_image, metric = "", fuzz = 0){
  out <- attributes(image_compare(image, reference_image, metric, fuzz))
  out$class = NULL
  out
}

#' @export
#' @rdname analysis
image_fft <- function(image){
  if(!isTRUE(magick_config()$fftw))
    stop("ImageMagick was configured without FFTW support.")
  assert_image(image)
  magick_image_fft(image)
}
