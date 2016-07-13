#' Manipulating Images
#'
#' Vectorized functions for manipulating images.
#'
#' @export
#' @rdname image-manipulate
#' @name image-manipulate
#' @inheritParams image-stl
#' @family image
#' @param format output format such as \code{png}, \code{jpeg}, \code{gif} or \code{pdf}.
image_format <- function(image, format){
  stopifnot(inherits(image, "magick-image"))
  magick_image_format(image, format)
}

#' @export
#' @rdname image-manipulate
#' @param delay time in 1/100ths of a second (0 to 65535) which must expire before displaying
#' the next image in an animated sequence.
image_delay <- function(image, delay){
  stopifnot(inherits(image, "magick-image"))
  magick_image_delay(image, delay)
}

#' @export
#' @rdname image-manipulate
image_trim <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_trim(image)
}

#' @export
#' @rdname image-manipulate
#' @param color a valid \href{https://www.imagemagick.org/Magick++/Color.html}{color string}
#' @param geometry a string with \href{https://www.imagemagick.org/Magick++/Geometry.html}{geometry syntax}
#' for example \code{"10x10+5-5"}.
image_border <- function(image, color = "", geometry = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_border(image, color, geometry)
}
