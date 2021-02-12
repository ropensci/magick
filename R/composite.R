#' Image Composite
#'
#' Similar to the ImageMagick `composite` utility: compose an image on top of another one using a
#' [CompositeOperator](https://www.imagemagick.org/Magick++/Enumerations.html#CompositeOperator).
#'
#' The `image_composite` function is vectorized over both image arguments: if the first image has
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
#' @param offset string with either a [gravity_type][gravity_types] or a [geometry_point][geometry_point]
#' to set position of top image.
#' @param operator string with a
#' [composite operator](https://www.imagemagick.org/Magick++/Enumerations.html#CompositeOperator)
#' from [compose_types()][compose_types]
#' @param composite_image composition image
#' @param compose_args additional arguments needed for some composite operations
#' @examples # Compose images using one of many operators
#' imlogo <- image_scale(image_read("logo:"), "x275")
#' rlogo <- image_read("https://jeroen.github.io/images/Rlogo-old.png")
#'
#' # Standard is atop
#' image_composite(imlogo, rlogo)
#'
#' # Same as 'blend 50' in the command line
#' image_composite(imlogo, rlogo, operator = "blend", compose_args="50")
#'
#' # Offset can be geometry or gravity
#' image_composite(logo, rose, offset = "+100+100")
#' image_composite(logo, rose, gravity = "East")
image_composite <- function(image, composite_image, operator = "atop",
                            offset = "+0+0", gravity = "northwest", compose_args = ""){
  assert_image(image)
  assert_image(composite_image)
  compose_args <- as.character(compose_args)

  # avoid some overhead
  if(length(composite_image) == 1){
    magick_image_composite(image, composite_image, offset, gravity, operator, compose_args)
  } else {
    # vectorize over both 1st and 2nd argument
    image_apply(composite_image, function(x){
      magick_image_composite(image, x, offset, gravity, operator, compose_args)
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

#' @export
#' @rdname composite
image_shadow_mask <- function(image, geometry = '50x10+30+30'){
  assert_image(image)
  geometry <- as.character(geometry)
  magick_image_shadow_mask(image, geometry)
}

#' @export
#' @rdname composite
#' @inheritParams edges
#' @examples image_shadow(imlogo)
image_shadow <- function(image, color = 'black', bg = 'white', geometry = '50x10+30+30',
                         operator = 'atop', offset = '+20+20'){
  assert_image(image)
  geometry <- as.character(geometry)
  input <- image_background(image, color, flatten = TRUE)
  shadow <- image_background(magick_image_shadow_mask(input, geometry), bg)
  image_join(lapply(seq_along(input), function(i){
    # Prevent double loop which results in n^2 output frames
    image_composite(shadow[i], image[i], operator = operator, offset = offset)
  }))
}

#' @export
#' @rdname composite
#' @inheritParams edges
#' @examples image_shade(imlogo)
#' @param azimuth position of light source
#' @param elevation position of light source
#' @param color Set to true to shade the red, green, and blue components of the image.
image_shade <- function(image, azimuth = 30, elevation = 30, color = FALSE){
  assert_image(image)
  azimuth <- as.numeric(azimuth)
  elevation <- as.numeric(elevation)
  color <- as.logical(color)
  magick_image_shade(image, azimuth, elevation, color)
}
