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
#' Other analysis functions will be added in future versions!
#'
#' @export
#' @family image
#' @name analysis
#' @rdname analysis
#' @inheritParams editing
#' @param reference_image another image to compare to
#' @param metric string with a [metric](http://www.imagemagick.org/script/command-line-options.php#metric)
#' from [metric_types()][metric_types].
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

#' @export
#' @rdname analysis
image_fft <- function(image){
  if(!isTRUE(magick_config()$fftw))
    stop("ImageMagick was configured without FFTW support. Reinstall with: brew reinstall imagemagick --with-fftw")
  assert_image(image)
  magick_image_fft(image)
}
