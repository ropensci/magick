#' Image Transform
#'
#' Basic transformations like rotate, resize, crop and flip. Details below.
#'
#' For details see [Magick++ STL](https://www.imagemagick.org/Magick++/STL.html)
#' documentation. Short descriptions:
#'
#' - [image_trim] removes edges that are the background color from the image.
#' - [image_chop] removes vertical or horizontal subregion of image.
#' - [image_crop] cuts out a subregion of original image
#' - [image_rotate] rotates and increases size of canvas to fit rotated image.
#' - [image_deskew] auto rotate to correct skewed images
#' - [image_resize] resizes using custom [filterType](https://www.imagemagick.org/Magick++/Enumerations.html#FilterTypes)
#' - [image_scale] and [image_sample] resize using simple ratio and pixel sampling algorithm.
#' - [image_flip] and [image_flop] invert image vertically and horizontally
#'
#' The most powerful resize function is [image_resize] which allows for setting
#' a custom resize filter. Output of [image_scale] is similar to `image_resize(img, filter = "point")`.
#'
#' For resize operations it holds that if no `geometry` is specified, all frames
#' are rescaled to match the top frame.
#' Examples of `geometry` strings:
#'  - __`"500x300"`__       -- *Resize image keeping aspect ratio, such that width does not exceed 500 and the height does not exceed 300.*
#'  - __`"500x300!"`__      -- *Resize image to 500 by 300, ignoring aspect ratio*
#'  - __`"500x"`__          -- *Resize width to 500 keep aspect ratio*
#'  - __`"x300"`__          -- *Resize height to 300 keep aspect ratio*
#'  - __\code{"50\%x20\%"}__ -- *Resize width to 50 percent and height to 20 percent of original*
#'  - __`"500x300+10+20"`__ -- *Crop image to 500 by 300 at position 10,20*
#'
#'
#' @name transform
#' @rdname transform
#' @inheritParams effects
#' @family image
#' @export
#' @examples
#' logo <- image_read("logo:")
#' logo <- image_scale(logo, "400")
#' image_trim(logo)
image_trim <- function(image){
  assert_image(image)
  magick_image_trim(image)
}

#' @export
#' @rdname transform
#' @param geometry a string with [geometry syntax](https://www.imagemagick.org/Magick++/Geometry.html)
#' specifying width+height and/or position offset. See details and examples below.
#' @examples
#' image_chop(logo, "100x20")
image_chop <- function(image, geometry){
  assert_image(image)
  stopifnot(is.character(geometry))
  magick_image_chop(image, geometry)
}

#' @export
#' @rdname transform
#' @param degrees value between 0 and 360 for how many degrees to rotate
#' @examples
#' image_rotate(logo, 45)
image_rotate <- function(image, degrees){
  assert_image(image)
  magick_image_rotate(image, degrees)
}

#' @export
#' @rdname transform
#' @param filter string with a [filtertype](https://www.imagemagick.org/Magick++/Enumerations.html#FilterTypes).
#' @examples # Small image
#' rose <- image_convert(image_read("rose:"), "png")
#'
#' # Resize to 400 width or height:
#' image_resize(rose, "400x")
#' image_resize(rose, "x400")
#'
#' # Resize keeping ratio
#' image_resize(rose, "400x400")
#'
#' # Resize, force size losing ratio
#' image_resize(rose, "400x400!")
#'
#' # Different filters
#' image_resize(rose, "400x", filter = "Triangle")
#' image_resize(rose, "400x", filter = "Point")
image_resize <- function(image, geometry = NULL, filter = NULL){
  assert_image(image)
  geometry <- as.character(geometry)
  filter <- as.character(filter)
  magick_image_resize(image, geometry, filter)
}

#' @export
#' @rdname transform
#' @examples # simple pixel resize
#' image_scale(rose, "400x")
image_scale <- function(image, geometry = NULL){
  assert_image(image)
  geometry <- as.character(geometry)
  magick_image_scale(image, geometry)
}

#' @export
#' @rdname transform
#' @examples image_sample(rose, "400x")
image_sample <- function(image, geometry = NULL){
  assert_image(image)
  magick_image_sample(image, geometry)
}

#' @export
#' @rdname transform
#' @examples image_crop(logo, "400x400+200+200")
image_crop <- function(image, geometry = NULL){
  assert_image(image)
  geometry <- as.character(geometry)
  magick_image_crop(image, geometry)
}

#' @export
#' @rdname transform
#' @examples
#' image_flip(logo)
image_flip <- function(image){
  assert_image(image)
  magick_image_flip(image)
}

#' @export
#' @rdname transform
#' @examples
#' image_flop(logo)
image_flop <- function(image){
  assert_image(image)
  magick_image_flop(image)
}

#' @export
#' @rdname transform
#' @param threshold straightens an image. A threshold of 40 works for most images.
image_deskew <- function(image, threshold = 40){
  assert_image(image)
  magick_image_deskew(image, threshold)
}

#' @export
#' @rdname transform
#' @param pagesize geometry string with preferred size and location of an image canvas
#' @param density geometry string with vertical and horizontal resolution in pixels of
#' the image. Specifies an image density when decoding a Postscript or PDF.
image_page <- function(image, pagesize = NULL, density = NULL){
  assert_image(image)
  pagesize <- as.character(pagesize)
  density <- as.character(density)
  magick_image_page(image, pagesize, density)
}
