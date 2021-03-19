#' Image Color
#'
#' Functions to adjust contrast, brightness, colors of the image. Details below.
#'
#' For details see [Magick++ STL](https://www.imagemagick.org/Magick++/STL.html)
#' documentation. Short descriptions:
#'
#'  - [image_modulate] adjusts brightness, saturation and hue of image relative to current.
#'  - [image_quantize] reduces number of unique colors in the image.
#'  - [image_ordered_dither] reduces number of unique colors using a dithering threshold map.
#'  - [image_map] replaces colors of image with the closest color from a reference image.
#'  - [image_channel] extracts a single channel from an image and returns as grayscale.
#'  - [image_transparent] sets pixels approximately matching given color to transparent.
#'  - [image_background] sets background color. When image is flattened, transparent pixels get background color.
#'  - [image_colorize] overlays a solid color frame using specified opacity.
#'  - [image_contrast] enhances intensity differences in image
#'  - [image_normalize] increases contrast by normalizing the pixel values to span the full range of colors
#'  - [image_enhance] tries to minimize noise
#'  - [image_equalize] equalizes using histogram equalization
#'  - [image_median] replaces each pixel with the median color in a circular neighborhood
#'
#' Note that
#' colors are also determined by image properties
#' [imagetype](https://www.imagemagick.org/Magick++/Enumerations.html#ImageType) and
#' [colorspace](https://www.imagemagick.org/Magick++/Enumerations.html#ColorspaceType)
#' which can be modified via [image_convert()].
#'
#' @export
#' @name color
#' @rdname color
#' @inheritParams painting
#' @family image
#' @param brightness modulation of brightness as percentage of the current value (100 for no change)
#' @param saturation modulation of saturation as percentage of the current value (100 for no change)
#' @param hue modulation of hue is an absolute rotation of -180 degrees to +180 degrees from the
#' current position corresponding to an argument range of 0 to 200 (100 for no change)
#' @examples
#' # manually adjust colors
#' logo <- image_read("logo:")
#' image_modulate(logo, brightness = 200)
#' image_modulate(logo, saturation = 150)
#' image_modulate(logo, hue = 200)
#'
image_modulate <- function(image, brightness = 100, saturation = 100, hue = 100){
  assert_image(image)
  brightness <- as.numeric(brightness)
  saturation <- as.numeric(saturation)
  hue <- as.numeric(hue)
  magick_image_modulate(image, brightness, saturation, hue)
}

#' @export
#' @rdname color
#' @param max preferred number of colors in the image. The actual number of colors in the image may
#' be less than your request, but never more.
#' @param dither a boolean (defaults to `TRUE`) specifying whether to apply Floyd/Steinberg error
#' diffusion to the image: averages intensities of several neighboring pixels
#' @param treedepth depth of the quantization color classification tree. Values of 0 or 1 allow
#' selection of the optimal tree depth for the color reduction algorithm. Values between 2 and 8
#' may be used to manually adjust the tree depth.
#' @examples
#' # Reduce image to 10 different colors using various spaces
#' image_quantize(logo, max = 10, colorspace = 'gray')
#' image_quantize(logo, max = 10, colorspace = 'rgb')
#' image_quantize(logo, max = 10, colorspace = 'cmyk')
#'
image_quantize <- function(image, max = 256, colorspace = 'rgb', dither = TRUE, treedepth = NULL){
  assert_image(image)
  max <- as.integer(max)
  colorspace <- as.character(colorspace)
  dither <- as.logical(dither)
  treedepth <- as.integer(treedepth)
  magick_image_quantize(image, max, colorspace, dither, treedepth)
}

#' @export
#' @rdname color
#' @param map reference image to map colors from
image_map <- function(image, map, dither = FALSE){
  assert_image(image)
  assert_image(map)
  dither <- as.logical(dither)
  magick_image_map(image, map, dither)
}

#' @export
#' @rdname color
#' @param threshold_map A string giving the dithering pattern to use. See
#' [the ImageMagick documentation](https://legacy.imagemagick.org/Usage/option_link.cgi?ordered-dither)
#' for possible values
#' @examples image_ordered_dither(logo, 'o8x8')
image_ordered_dither <- function(image, threshold_map){
  assert_image(image)
  threshold_map <- as.character(threshold_map)
  magick_image_ordered_dither(image, threshold_map)
}

#' @export
#' @rdname color
#' @param channel a string with a
#' [channel](https://www.imagemagick.org/Magick++/Enumerations.html#ChannelType) from
#' [channel_types][channel_types] for example `"alpha"` or `"hue"` or `"cyan"`
image_channel <- function(image, channel = 'lightness'){
  magick_image_channel(image, channel)
}

#' @export
#' @rdname color
image_separate <- function(image, channel = 'default'){
  magick_image_separate(image, channel)
}

#' @export
#' @rdname color
image_combine <- function(image, colorspace = 'sRGB', channel = 'default'){
  channel <- as.character(channel)
  colorspace <- as.character(colorspace)
  magick_image_combine(image, colorspace, channel)
}

#' @export
#' @rdname color
image_transparent <- function(image, color, fuzz = 0){
  assert_image(image)
  if(fuzz > 100)
    stop("Parameter 'fuzz' must be percentage value (0-100)")
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
#' # Compare to flood-fill method:
#' image_fill(logo, "pink", fuzz = 20)
#'
image_background <- function(image, color, flatten = TRUE){
  assert_image(image)
  out <- magick_image_background(image, color)
  if(isTRUE(flatten)){
    image_apply(out, image_flatten)
  } else {
    return(out)
  }
}

#' @export
#' @rdname color
#' @param opacity percentage of opacity used for coloring
#' @examples
#' # Other color tweaks
#' image_colorize(logo, 50, "red")
image_colorize <- function(image, opacity, color){
  assert_image(image)
  magick_image_colorize(image, opacity, color)
}

#' @export
#' @rdname color
#' @param sharpen enhance intensity differences in image
#' @examples
#' image_contrast(logo)
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
#'
#' # Alternate way to convert into black-white
#' image_convert(logo, type = 'grayscale')
image_median <- function(image, radius = 1.0){
  assert_image(image)
  magick_image_median(image, radius)
}
