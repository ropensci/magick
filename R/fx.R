#' Image FX
#'
#' Apply a custom an [fx expression](https://www.imagemagick.org/script/fx.php) to the image.
#'
#' There are two different interfaces. The [image_fx] function simply applies
#' the same fx to each frame in the input image. The [image_fx_sequence] function
#' on the other hand treats the entire input vector as a sequence, allowing you
#' to apply an expression with multiple input images. See examples.
#'
#' @export
#' @inheritParams thresholding
#' @rdname fx
#' @name fx
#' @family image
#' @param expression string with an [fx expression](https://www.imagemagick.org/script/fx.php)
#' @examples # Show image_fx() expression
#' img <- image_convert(logo, colorspace = "Gray")
#' gradient_x <- image_convolve(img, kernel = "Prewitt")
#' gradient_y <- image_convolve(img, kernel = "Prewitt:90")
#' gradient <- c(image_fx(gradient_x, expression = "p^2"),
#'                 image_fx(gradient_y, expression = "p^2"))
#' gradient <- image_flatten(gradient, operator = "Plus")
#' #gradient <- image_fx(gradient, expression = "sqrt(p)")
#' gradient
#'
#' \donttest{
#' image_fx(img, expression = "pow(p, 0.5)")
#' image_fx(img, expression = "rand()")
#' }
image_fx <- function(image, expression = "p", channel = NULL){
  assert_image(image)
  expression <- as.character(expression)
  channel <- as.character(channel)
  magick_image_fx(image, expression, channel)
}


#' @rdname fx
#' @export
#' @examples # Use multiple source images
#' input <- c(logo, image_flop(logo))
#' image_fx_sequence(input, "(u+v)/2")
image_fx_sequence <- function(image, expression = "p"){
  expression <- as.character(expression)
  magick_image_fx_sequence(image, expression)
}
