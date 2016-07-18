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
