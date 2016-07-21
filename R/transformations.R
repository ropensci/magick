#' Image Transformations
#'
#' Vectorized functions for transforming images. These functions apply
#' the same transformation to each frame in the image.
#' The \href{https://www.imagemagick.org/Magick++/STL.html}{Magick++ documentation}
#' explains meaning of each function and parameter. See \link{editing} for
#' functions to read or combine image sequences.
#'
#' Each function returns a copy of the manipulated image; the input image will
#' be unaffected. Therefore operations can be piped with magrittr if you're
#' into that kind of stuff.
#'
#' Besides these functions also R-base functions such as \code{c()}, \code{[},
#' \code{as.list()}, \code{rev}, \code{length}, and \code{print} can be used
#' to work with image frames.
#'
#' @export
#' @rdname transformations
#' @name transformations
#' @inheritParams editing
#' @family image
#' @param format output format such as \code{png}, \code{jpeg}, \code{gif} or \code{pdf}.
image_format <- function(image, format){
  stopifnot(inherits(image, "magick-image"))
  magick_image_format(image, format)
}

#' @export
#' @rdname transformations
#' @examples
#' logo <- image_read(system.file("Rlogo.png", package = "magick"))
#' logo <- image_scale(logo, "400")
#' image_trim(logo)
image_trim <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_trim(image)
}

#' @export
#' @rdname transformations
image_background <- function(image, color){
  stopifnot(inherits(image, "magick-image"))
  magick_image_background(image, color)
}

#' @export
#' @rdname transformations
#' @examples image_crop(logo, "400x400+200+200")
image_crop <- function(image, geometry = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_crop(image, geometry)
}

#' @export
#' @rdname transformations
#' @examples image_scale(logo, "200x200")
image_scale <- function(image, geometry = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_scale(image, geometry)
}

#' @export
#' @rdname transformations
#' @examples image_sample(logo, "200x200")
image_sample <- function(image, geometry = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_sample(image, geometry)
}

#' @export
#' @rdname transformations
#' @param color a valid \href{https://www.imagemagick.org/Magick++/Color.html}{color string}
#' @param geometry a string with \href{https://www.imagemagick.org/Magick++/Geometry.html}{geometry syntax}
#' for example \code{"10x10+5-5"}.
#' @examples image_border(logo, "red", "10x10")
image_border <- function(image, color = "", geometry = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_border(image, color, geometry)
}

#' @export
#' @rdname transformations
#' @param noisetype integer betwee 0 and 5 with
#' \href{https://www.imagemagick.org/Magick++/Enumerations.html#NoiseType}{noisetype}.
#' @examples
#' image_noise(logo)
image_noise <- function(image, noisetype = "gaussian"){
  stopifnot(inherits(image, "magick-image"))
  magick_image_noise(image, noisetype)
}

#' @export
#' @rdname transformations
#' @param radius the radius of the Gaussian, in pixels, not counting the center pixel.
#' @param sigma the standard deviation of the Laplacian, in pixels.
#' @examples
#' image_blur(logo, 10, 10)
image_blur <- function(image, radius = 1, sigma = 0.5){
  stopifnot(inherits(image, "magick-image"))
  magick_image_blur(image, radius, sigma)
}

#' @export
#' @rdname transformations
#' @examples
#' image_charcoal(logo)
image_charcoal <- function(image, radius = 1, sigma = 0.5){
  stopifnot(inherits(image, "magick-image"))
  magick_image_charcoal(image, radius, sigma)
}

#' @export
#' @rdname transformations
#' @examples
#' image_edge(logo)
image_edge <- function(image, radius = 1){
  stopifnot(inherits(image, "magick-image"))
  magick_image_edge(image, radius)
}

#' @export
#' @rdname transformations
#' @examples
#' image_oilpaint(logo)
image_oilpaint <- function(image, radius = 1){
  stopifnot(inherits(image, "magick-image"))
  magick_image_oilpaint(image, radius)
}

#' @export
#' @rdname transformations
#' @examples
#' image_emboss(logo)
image_emboss <- function(image, radius = 1, sigma = 0.5){
  stopifnot(inherits(image, "magick-image"))
  magick_image_emboss(image, radius, sigma)
}

#' @export
#' @rdname transformations
#' @examples
#' image_enhance(logo)
image_enhance <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_enhance(image)
}

#' @export
#' @rdname transformations
#' @examples
#' image_equalize(logo)
image_equalize <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_equalize(image)
}

#' @export
#' @rdname transformations
#' @examples
#' image_flip(logo)
image_flip <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_flip(image)
}

#' @export
#' @rdname transformations
#' @examples
#' image_flop(logo)
image_flop <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_flop(image)
}

# lol this is so ugly it should be illegal
#' @export
#' @rdname transformations
#' @examples
#' image_frame(logo)
image_frame <- function(image, geometry = "25x25+6+6"){
  stopifnot(inherits(image, "magick-image"))
  magick_image_frame(image, geometry)
}

#' @export
#' @rdname transformations
#' @param factor image implode factor (special effect)
#' @examples
#' image_implode(logo)
image_implode <- function(image, factor = 0.5){
  stopifnot(inherits(image, "magick-image"))
  magick_image_implode(image, factor)
}


#' @export
#' @rdname transformations
#' @examples
#' image_negate(logo)
image_negate <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_negate(image)
}

#' @export
#' @rdname transformations
#' @examples
#' image_normalize(logo)
image_normalize <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_normalize(image)
}

#' @export
#' @rdname transformations
#' @param degrees how many degrees
#' @examples
#' image_rotate(logo, 45)
image_rotate <- function(image, degrees){
  stopifnot(inherits(image, "magick-image"))
  magick_image_rotate(image, degrees)
}

#' @export
#' @rdname transformations
#' @param point string indicating the flood-fill starting point
#' @param fuzz Colors within this distance are considered equal.
#' Use this option to match colors that are close to the target color in RGB space.
#' I think max distance (from #000000 to #FFFFFF) is 256^3.
#' @examples
#' image_fill(logo, "red")
#' image_fill(logo, "red", fuzz = 256^2)
image_fill <- function(image, color, point = "1x1", fuzz = 0){
  stopifnot(inherits(image, "magick-image"))
  magick_image_fill(image, color, point, fuzz)
}

#' @export
#' @rdname transformations
#' @examples
#' # chops off 100 pixels from left and 20 from top
#' image_chop(logo, "100x20")
image_chop <- function(image, geometry){
  stopifnot(inherits(image, "magick-image"))
  stopifnot(is.character(geometry))
  magick_image_chop(image, geometry)
}

#' @export
#' @rdname transformations
#' @param opacity percentage of transparency
#' @examples
#' image_colorize(logo, 50, "red")
image_colorize <- function(image, opacity, color){
  stopifnot(inherits(image, "magick-image"))
  magick_image_colorize(image, opacity, color)
}

#' @export
#' @rdname transformations
#' @param offset geometry string with offset
#' @param operator string with a
#' \href{https://www.imagemagick.org/Magick++/Enumerations.html#CompositeOperator}{composite operator}.
#' @param composite_image composition image
#' @examples
#' oldlogo <- image_read(system.file("Rlogo-old.png", package = "magick"))
#' image_composite(logo, oldlogo)
#' image_composite(logo, oldlogo, operator = "copyred")
image_composite <- function(image, composite_image = image[1], operator = "atop", offset = "0x0"){
  stopifnot(inherits(image, "magick-image"))
  stopifnot(inherits(composite_image, "magick-image"))
  magick_image_composite(image, composite_image, offset, operator)
}

#' @export
#' @rdname transformations
#' @param sharpen enhance intensity differences in image
#' @examples
#' test <- image_scale(oldlogo, "400x400")
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

#' @export
#' @rdname transformations
#' @param text annotation text
#' @param gravity string with
#' \href{https://www.imagemagick.org/Magick++/Enumerations.html#GravityType}{gravity type}
#' @param location geometry string with location relative to \code{gravity}
#' @param size font-size in pixels
#' @param boxcolor Base color that annotation text is rendered on.
#' @param font Text rendering font. To use a TrueType font, precede the TrueType filename with an @.
#' @examples image_annotate(logo, "This is a test")
#' image_annotate(logo, "APPROVED", size = 50, boxcolor = "yellow",
#'    color = "red", degrees = 30, location = "+100+100")
image_annotate <- function(image, text, gravity = "northwest", location = "+0+0", degrees = 0,
                           color = NULL, boxcolor = NULL, font = NULL, size = NULL){
  stopifnot(inherits(image, "magick-image"))
  color <- as.character(color)
  boxcolor <- as.character(boxcolor)
  font <- as.character(font)
  size <- as.integer(size)
  magick_image_annotate(image, text, gravity, location, degrees, color, boxcolor, font, size)
}
