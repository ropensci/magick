#' Image FX
#'
#' Apply a custom an [fx expression](https://www.imagemagick.org/script/fx.php) to the image.
#'
#' @export
#' @inheritParams thresholding
#' @rdname fx
#' @name fx
#' @family image
#' @param expression string with an [fx expression](https://www.imagemagick.org/script/fx.php)
#' @examples # Show image_fx() expression
#' if(magick_config()$version > "6.8.8"){
#' img <- image_convert(logo, colorspace = "Gray")
#' image_fx(img, expression = "pow(p, 0.5)")
#' image_fx(img, expression = "rand()")
#'
#' gradient_x <- image_convolve(img, kernel = "Prewitt")
#' gradient_y <- image_convolve(img, kernel = "Prewitt:90")
#' gradient <- c(image_fx(gradient_x, expression = "p^2"),
#'                 image_fx(gradient_y, expression = "p^2"))
#' gradient <- image_flatten(gradient, operator = "Plus")
#' #gradient <- image_fx(gradient, expression = "sqrt(p)")
#' gradient
#' }
image_fx <- function(image, expression = "p", channel = NULL){
  assert_image(image)
  expression <- as.character(expression)
  channel <- as.character(channel)
  magick_image_fx(image, expression, channel)
}
