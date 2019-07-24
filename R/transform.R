#' Image Transform
#'
#' Basic transformations like rotate, resize, crop and flip. The [geometry] syntax
#' is used to specify sizes and areas.
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
#' @name transform
#' @rdname transform
#' @inheritParams effects
#' @inheritParams painting
#' @family image
#' @export
#' @examples
#' logo <- image_read("logo:")
#' logo <- image_scale(logo, "400")
#' image_trim(logo)
image_trim <- function(image, fuzz = 0){
  assert_image(image)
  fuzz <- as.numeric(fuzz)
  magick_image_trim(image, fuzz)
}

#' @export
#' @rdname transform
#' @param geometry a [geometry][geometry] string specifying area (for cropping) or size (for resizing).
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
#' @param filter string with [filter](https://www.imagemagick.org/Magick++/Enumerations.html#FilterTypes)
#' type from: [filter_types][filter_types]
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
#' @inheritParams painting
#' @param repage resize the canvas to the cropped area
#' @examples image_crop(logo, "400x400+200+200")
image_crop <- function(image, geometry = NULL, gravity = NULL, repage = TRUE){
  assert_image(image)
  geometry <- as.character(geometry)
  gravity <- as.character(gravity)
  magick_image_crop(image, geometry, gravity, repage)
}

#' @export
#' @rdname transform
#' @examples image_extent(rose, '200x200', color = 'pink')
image_extent <- function(image, geometry, gravity = "center", color = "none"){
  assert_image(image)
  geometry <- as.character(geometry)
  gravity <- as.character(gravity)
  magick_image_extent(image, geometry, gravity, color)
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

#' @export
#' @rdname transform
image_repage <- function(image){
  magick_image_repage(image)
}

#' @export
#' @rdname transform
#' @param orientation string to set image orientation one of the [orientation_types].
#' If `NULL` it applies auto-orientation which tries to infer the correct orientation
#' from the Exif data.
#' @examples
#' if(magick_config()$version > "6.8.6")
#'   image_orient(logo)
image_orient <- function(image, orientation = NULL){
  assert_image(image)
  orientation <- as.character(orientation)
  magick_image_orient(image, orientation)
}

#' @export
#' @rdname transform
#' @examples
#' image_shear(logo, "10x10")
image_shear <- function(image, geometry = "10x10", color = "none"){
  assert_image(image)
  stopifnot(is.character(geometry))
  stopifnot(is.character(color))
  magick_image_shear(image, geometry, color)
}
