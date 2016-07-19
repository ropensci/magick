#' Image Attributes
#'
#' Functions to get or set Image attributes.
#'
#' @export
#' @rdname image-attributes
#' @name image-attributes
#' @inheritParams image-read
#' @family image
image_info <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_info(image)
}


#' @export
#' @rdname image-attributes
#' @param delay time in 1/100ths of a second (0 to 65535) which must expire before displaying
#' the next image in an animated sequence.
image_delay <- function(image, delay){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_delay(image, delay)
}
