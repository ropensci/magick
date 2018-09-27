#' Image Attributes
#'
#' Attributes are properties of the image that might be present on some images
#' and might affect image manipulation methods.
#'
#' Each attribute can be get and set with the same function. The [image_info()]
#' function returns a data frame with some commonly used attributes.
#'
#' @export
#' @family image
#' @inheritParams editing
#' @name attributes
#' @rdname attributes
#' @param comment string to set an image comment
image_comment <- function(image, comment = NULL){
  assert_image(image)
  comment <- as.character(comment)
  magick_attr_comment(image, comment)
}

#' @export
#' @rdname attributes
image_info <- function(image){
  assert_image(image)
  df <- magick_image_info(image)
  df_to_tibble(df)
}
