#' Image Color
#'
#' Functions to adjust contrast, brightness, colors of the image.
#'
#' @name color
#' @rdname color
#' @inheritParams painting
#' @export
#' @param sharpen enhance intensity differences in image
#' @examples logo <- image_read("logo:")
#' image_contrast(logo)
#'
#' # Convert to black-white
#' image_convert(logo, type = 'grayscale')
image_contrast <- function(image, sharpen = 1){
  assert_image(image)
  magick_image_contrast(image, sharpen)
}

#' @export
#' @rdname color
#' @examples
#' image_normalize(logo)
image_normalize <- function(image){
  assert_image(image)
  magick_image_normalize(image)
}

#' @export
#' @rdname color
#' @family image
#' @param brightness modulation of brightness as percentage of the current value (100 for no change)
#' @param saturation modulation of saturation as percentage of the current value (100 for no change)
#' @param hue modulation of hue is an absolute rotation of -180 degrees to +180 degrees from the
#' current position corresponding to an argument range of 0 to 200 (100 for no change)
#' @examples image_modulate(logo, brightness = 200)
#' image_modulate(logo, saturation = 150)
#' image_modulate(logo, hue = 200)
image_modulate <- function(image, brightness = 100, saturation = 100, hue = 100){
  assert_image(image)
  brightness <- as.numeric(brightness)
  saturation <- as.numeric(saturation)
  hue <- as.numeric(hue)
  magick_image_modulate(image, brightness, saturation, hue)
}

#' @export
#' @rdname color
#' @param opacity percentage of opacity used for coloring
#' @examples
#' image_colorize(logo, 50, "red")
image_colorize <- function(image, opacity, color){
  assert_image(image)
  magick_image_colorize(image, opacity, color)
}

#' @export
#' @rdname color
#' @examples
#' image_enhance(logo)
image_enhance <- function(image){
  assert_image(image)
  magick_image_enhance(image)
}

#' @export
#' @rdname color
#' @examples
#' image_equalize(logo)
image_equalize <- function(image){
  assert_image(image)
  magick_image_equalize(image)
}

#' @export
#' @rdname color
#' @param radius replace each pixel with the median color in a circular neighborhood
#' @examples image_median(logo)
image_median <- function(image, radius = 1.0){
  assert_image(image)
  magick_image_median(image, radius)
}

#' @export
#' @rdname color
#' @param max preferred number of colors in the image. The actual number of colors in the image may
#' be less than your request, but never more.
#' @param dither apply Floyd/Steinberg error diffusion to the image: averages intensities of sseveral
#' neighboring pixels
#' @param treedepth depth of the quantization color classification tree. Values of 0 or 1 allow
#' selection of the optimal tree depth for the color reduction algorithm. Values between 2 and 8
#' may be used to manually adjust the tree depth.
#' @examples
#' # Quantize into 10 colors, using various spaces
#' image_quantize(logo, max = 10, colorspace = 'gray')
#' image_quantize(logo, max = 10, colorspace = 'rgb')
#' image_quantize(logo, max = 10, colorspace = 'cmyk')
image_quantize <- function(image, max = 256, colorspace = NULL, dither = NULL, treedepth = NULL){
  assert_image(image)
  max <- as.integer(max)
  colorspace <- as.character(colorspace)
  dither <- as.logical(dither)
  treedepth <- as.integer(treedepth)
  magick_image_quantize(image, max, colorspace, dither, treedepth)
}

#' @export
#' @rdname color
image_transparent <- function(image, color, fuzz = 0){
  assert_image(image)
  magick_image_transparent(image, color, fuzz)
}

#' @export
#' @rdname color
#' @inheritParams editing
#' @examples
#' # Change background color
#' translogo <- image_transparent(logo, 'white')
#' image_background(translogo, "pink", flatten = TRUE)
#'
#' # Let's try another method
#' image_fill(logo, "pink", fuzz = 10000)
image_background <- function(image, color, flatten = TRUE){
  assert_image(image)
  out <- magick_image_background(image, color)
  if(isTRUE(flatten)){
    image_apply(out, image_flatten)
  } else {
    return(out)
  }
}
