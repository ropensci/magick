#' Magick Composite
#'
#' Similar to the ImageMagick `composite` command.
#'
#' @export
#' @rdname composite
#' @name composite
#' @inheritParams transformations
#' @param offset geometry string with offset
#' @param operator string with a
#' \href{https://www.imagemagick.org/Magick++/Enumerations.html#CompositeOperator}{composite operator}.
#' @param composite_image composition image
#' @param compose_args additional arguments needed for some composite operations
#' @examples # Compose images using one of many operators
#' imlogo <- image_scale(image_read("logo:"), "x275")
#' rlogo <- image_read("https://developer.r-project.org/Logo/Rlogo-3.png")
#' image_composite(imlogo, rlogo)
#' image_composite(imlogo, rlogo, operator = "blend", compose_args="50")
image_composite <- function(image, composite_image = image[1], operator = "atop", offset = "0x0", compose_args = ""){
  assert_image(image)
  stopifnot(inherits(composite_image, "magick-image"))
  compose_args <- as.character(compose_args)
  magick_image_composite(image, composite_image, offset, operator, compose_args)
}
