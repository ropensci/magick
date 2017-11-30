#' Image Composite
#'
#' Similar to the ImageMagick `composite` utility: compose an image on top of another one using a
#' [CompositeOperator](https://www.imagemagick.org/Magick++/Enumerations.html#CompositeOperator).
#'
#' The `image_compose` function is vectorized over both image arguments: if the first image has
#' `n` frames and the second `m` frames, the output image will contain `n` * `m` frames.
#'
#' The [image_border] function creates a slightly larger solid color frame and then composes the
#' original frame on top. The [image_frame] function is similar but has an additional feature to
#' create a shadow effect on the border (which is really ugly).
#'
#' @export
#' @rdname composite
#' @name composite
#' @family image
#' @inheritParams editing
#' @inheritParams painting
#' @param offset a [geometry_point][geometry_point] string to set x/y offset of top image
#' @param operator string with a
#' [composite operator](https://www.imagemagick.org/Magick++/Enumerations.html#CompositeOperator)
#' from [compose_types()][compose_types]
#' @param composite_image composition image
#' @param compose_args additional arguments needed for some composite operations
#' @examples # Compose images using one of many operators
#' imlogo <- image_scale(image_read("logo:"), "x275")
#' rlogo <- image_read("https://developer.r-project.org/Logo/Rlogo-3.png")
#'
#' # Standard is atop
#' image_composite(imlogo, rlogo)
#'
#' # Same as 'blend 50' in the command line
#' image_composite(imlogo, rlogo, operator = "blend", compose_args="50")
image_composite <- function(image, composite_image, operator = "atop", offset = "+0+0", compose_args = ""){
  assert_image(image)
  assert_image(composite_image)
  compose_args <- as.character(compose_args)

  # avoid some overhead
  if(length(composite_image) == 1){
    magick_image_composite(image, composite_image, offset, operator, compose_args)
  } else {
    # vectorize over both 1st and 2nd argument
    image_apply(composite_image, function(x){
      magick_image_composite(image, x, offset, operator, compose_args)
    })
  }
}


#' @export
#' @rdname composite
#' @param geometry a [geometry string](https://www.imagemagick.org/Magick++/Geometry.html)
#' to set height and width of the border, e.g. `"10x8"`. In addition [image_frame] allows
#' for adding shadow by setting an offset e.g. `"20x10+7+2"`.
#' @examples
#'
#' # Add a border frame around the image
#' image_border(imlogo, "red", "10x10")
image_border <- function(image, color = "lightgray", geometry = "10x10", operator = "copy"){
  assert_image(image)
  color <- as.character(color)
  geometry <- as.character(geometry)
  operator <- as.character(operator)
  magick_image_border(image, color, geometry, operator)
}

#' @export
#' @rdname composite
#' @examples
#' image_frame(imlogo)
image_frame <- function(image, color = "lightgray", geometry = "25x25+6+6"){
  assert_image(image)
  color <- as.character(color)
  geometry <- as.character(geometry)
  magick_image_frame(image, color, geometry)
}
