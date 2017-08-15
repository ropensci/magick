#' Image Contrast and Colors
#'
#' Functions to adjust constrast and colors.
#'
#' @name contrast
#' @rdname contrast
#' @inheritParams transformations
#' @export
#' @param sharpen enhance intensity differences in image
#' @examples logo <- image_read("logo:")
#' image_contrast(logo)
image_contrast <- function(image, sharpen = 1){
  assert_image(image)
  magick_image_contrast(image, sharpen)
}

#' @export
#' @rdname contrast
#' @examples
#' image_normalize(logo)
image_normalize <- function(image){
  assert_image(image)
  magick_image_normalize(image)
}

#' @export
#' @rdname contrast
#' @param brightness modulation of brightness as a ratio of the current value (1.0 for no change)
#' @param saturation modulation of saturation as a ratio of the current value (1.0 for no change)
#' @param hue modulation of hue is an absolute rotation of -180 degrees to +180 degrees from the
#' current position corresponding to an argument range of 0 to 2.0 (1.0 for no change)
#' @examples image_modulate(logo, 1.1)
#' image_modulate(logo, saturation = 0.9)
#' image_modulate(logo, hue = 1.1)
image_modulate <- function(image, brightness = 1.0, saturation = 1.0, hue = 1.0){
  assert_image(image)
  brightness <- as.numeric(brightness)
  saturation <- as.numeric(saturation)
  hue <- as.numeric(hue)
  magick_image_modulate(image, brightness, saturation, hue)
}

#' @export
#' @rdname contrast
#' @param opacity percentage of opacity used for coloring
#' @examples
#' image_colorize(logo, 50, "red")
image_colorize <- function(image, opacity, color){
  assert_image(image)
  magick_image_colorize(image, opacity, color)
}

#' @export
#' @rdname contrast
#' @examples
#' image_enhance(logo)
image_enhance <- function(image){
  assert_image(image)
  magick_image_enhance(image)
}

#' @export
#' @rdname contrast
#' @examples
#' image_equalize(logo)
image_equalize <- function(image){
  assert_image(image)
  magick_image_equalize(image)
}

#' @export
#' @rdname contrast
#' @examples image_median(logo)
image_median <- function(image, radius = 1.0){
  assert_image(image)
  magick_image_median(image, radius)
}
