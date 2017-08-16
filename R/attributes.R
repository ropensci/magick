#' Image Attributes
#'
#' Attributes are properties of the image that might be present on some images
#' and might affect image manipualation methods. Each attribute can be get and
#' set with the same function.
#'
#' @export
#' @family image
#' @name attributes
#' @rdname attributes
#' @param comment string to set an image comment
image_comment <- function(image, comment = NULL){
  assert_image(image)
  comment <- as.character(comment)
  magick_attr_comment(image, comment)
}
