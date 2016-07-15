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
#' @examples
#' logo <- image_read(system.file("Rlogo.png", package = "magick"))
#' image_trim(logo)
image_trim <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_trim(image)
}

#' @export
#' @rdname image-manipulate
image_background <- function(image, color){
  stopifnot(inherits(image, "magick-image"))
  magick_image_background(image, color)
}

#' @export
#' @rdname image-manipulate
#' @param matte if the image has transparency. If set True, store matte channel
#' if the image has one otherwise create an opaque one.
#' @examples
#' image_matte(logo, color = "red")
image_matte <- function(image, matte = TRUE, color = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_matte(image, matte, color)
}

#' @export
#' @rdname image-manipulate
#' @examples image_pen(logo, color = "red")
image_pen <- function(image, color){
  stopifnot(inherits(image, "magick-image"))
  magick_image_pen(image, color)
}


#' @export
#' @rdname image-manipulate
#' @examples image_crop(logo, "400x400+200+200")
image_crop <- function(image, geometry = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_crop(image, geometry)
}

#' @export
#' @rdname image-manipulate
#' @examples image_scale(logo, "200x200")
image_scale <- function(image, geometry = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_scale(image, geometry)
}

#' @export
#' @rdname image-manipulate
#' @param color a valid \href{https://www.imagemagick.org/Magick++/Color.html}{color string}
#' @param geometry a string with \href{https://www.imagemagick.org/Magick++/Geometry.html}{geometry syntax}
#' for example \code{"10x10+5-5"}.
#' @examples image_border(logo, "red", "10x10")
image_border <- function(image, color = "", geometry = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_border(image, color, geometry)
}

#' @export
#' @rdname image-manipulate
#' @param noisetype integer betwee 0 and 5 with
#' \href{https://www.imagemagick.org/Magick++/Enumerations.html#NoiseType}{noisetype}.
#' @examples
#' image_noise(logo)
image_noise <- function(image, noisetype = 2){
  stopifnot(inherits(image, "magick-image"))
  magick_image_noise(image, noisetype)
}

#' @export
#' @rdname image-manipulate
#' @param radius the radius of the Gaussian, in pixels, not counting the center pixel.
#' @param sigma the standard deviation of the Laplacian, in pixels.
#' @examples
#' image_blur(logo, 10, 10)
image_blur <- function(image, radius = 1, sigma = 0.5){
  stopifnot(inherits(image, "magick-image"))
  magick_image_blur(image, radius, sigma)
}

#' @export
#' @rdname image-manipulate
#' @examples
#' image_charcoal(logo)
image_charcoal <- function(image, radius = 1, sigma = 0.5){
  stopifnot(inherits(image, "magick-image"))
  magick_image_charcoal(image, radius, sigma)
}

#' @export
#' @rdname image-manipulate
#' @examples
#' image_edge(logo)
image_edge <- function(image, radius = 1){
  stopifnot(inherits(image, "magick-image"))
  magick_image_edge(image, radius)
}

#' @export
#' @rdname image-manipulate
#' @examples
#' image_emboss(logo)
image_emboss <- function(image, radius = 1, sigma = 0.5){
  stopifnot(inherits(image, "magick-image"))
  magick_image_emboss(image, radius, sigma)
}

#' @export
#' @rdname image-manipulate
#' @examples
#' image_enhance(logo)
image_enhance <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_enhance(image)
}

#' @export
#' @rdname image-manipulate
#' @examples
#' image_equalize(logo)
image_equalize <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_equalize(image)
}

#' @export
#' @rdname image-manipulate
#' @examples
#' image_flip(logo)
image_flip <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_flip(image)
}

#' @export
#' @rdname image-manipulate
#' @examples
#' # chops off 100 pixels from left and 20 from top
#' image_chop(logo, "100x20")
image_chop <- function(image, geometry){
  stopifnot(inherits(image, "magick-image"))
  stopifnot(is.character(geometry))
  magick_image_chop(image, geometry)
}

#' @export
#' @rdname image-manipulate
#' @param opacity percentage of transparency
#' @examples
#' image_colorize(logo, 50, "red")
image_colorize <- function(image, opacity, color){
  stopifnot(inherits(image, "magick-image"))
  magick_image_colorize(image, opacity, color)
}

#' @export
#' @rdname image-manipulate
#' @param offset geometry string with offset
#' @param operator integer specifying the
#' \href{https://www.imagemagick.org/Magick++/Enumerations.html#CompositeOperator}{composite operator}.
#' @param composite_image composition image
#' @examples
#' image_composite(logo, operator = 2)
image_composite <- function(image, composite_image = image[1], operator = 1, offset = "0x0"){
  stopifnot(inherits(image, "magick-image"))
  stopifnot(inherits(composite_image, "magick-image"))
  magick_image_composite(image, composite_image, offset, operator)
}

#' @export
#' @rdname image-manipulate
#' @param sharpen enhance intensity differences in image
#' @examples
#' test <- image_read(system.file("Rlogo-old.png", package = "magick"))
#' test <- image_scale(test, "400x400")
#' out <- list()
#' for(i in 1:10){
#'   out[[i]] <- test
#'   test <- image_contrast(test)
#' }
#' animation <- do.call(c, out)
#' image_format(animation, "gif")
image_contrast <- function(image, sharpen = 1){
  stopifnot(inherits(image, "magick-image"))
  magick_image_contrast(image, sharpen)
}
