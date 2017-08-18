#' Resize, Cut, Crop, Rotate
#'
#' Basic transformation and cutting operations.
#'
#' The most powerful resize function is \code{image_resize} which allows for setting
#' a custom resize filter. Functions \code{image_scale} and \code{image_sample} are
#' similar to \code{image_resize(img, filter = "point")}.
#'
#' For resize operations it holds that if no \code{geometry} is specified, all frames
#' are rescaled to match the top frame.
#'
#' @name resize
#' @rdname resize
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
#' @rdname resize
#' @param geometry a string with \href{https://www.imagemagick.org/Magick++/Geometry.html}{geometry syntax}
#' specifying width+height and/or position offset.
#' @examples
#' image_chop(logo, "100x20")
image_chop <- function(image, geometry){
  assert_image(image)
  stopifnot(is.character(geometry))
  magick_image_chop(image, geometry)
}

#' @export
#' @rdname resize
#' @param degrees value between 0 and 360 for how many degrees to rotate
#' @examples
#' image_rotate(logo, 45)
image_rotate <- function(image, degrees){
  assert_image(image)
  magick_image_rotate(image, degrees)
}

#' @export
#' @rdname resize
#' @param filter string with a \href{https://www.imagemagick.org/Magick++/Enumerations.html#FilterTypes}{filtertype}.
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
#' @rdname resize
#' @examples # simple pixel resize
#' image_scale(rose, "400x")
image_scale <- function(image, geometry = NULL){
  assert_image(image)
  geometry <- as.character(geometry)
  magick_image_scale(image, geometry)
}

#' @export
#' @rdname resize
#' @examples image_sample(rose, "400x")
image_sample <- function(image, geometry = NULL){
  assert_image(image)
  magick_image_sample(image, geometry)
}

#' @export
#' @rdname resize
#' @examples image_crop(logo, "400x400+200+200")
image_crop <- function(image, geometry = NULL){
  assert_image(image)
  geometry <- as.character(geometry)
  magick_image_crop(image, geometry)
}

#' @export
#' @rdname resize
#' @examples
#' image_flip(logo)
image_flip <- function(image){
  assert_image(image)
  magick_image_flip(image)
}

#' @export
#' @rdname resize
#' @examples
#' image_flop(logo)
image_flop <- function(image){
  assert_image(image)
  magick_image_flop(image)
}

#' @export
#' @rdname resize
#' @param treshold straightens an image. A threshold of 40 works for most images.
image_deskew <- function(image, treshold = 40){
  assert_image(image)
  magick_image_deskew(image, treshold)
}

#' @export
#' @rdname resize
#' @param pagesize geometry string with preferred size and location of an image canvas
#' @param density geometry string with vertical and horizontal resolution in pixels of
#' the image. Specifies an image density when decoding a Postscript or PDF.
image_page <- function(image, pagesize = NULL, density = NULL){
  assert_image(image)
  pagesize <- as.character(pagesize)
  density <- as.character(density)
  magick_image_page(image, pagesize, density)
}
