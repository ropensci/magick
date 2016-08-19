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
#' @name transformations
#' @inheritParams editing
#' @family image
#' @export
#' @rdname transformations
#' @examples
#' logo <- image_read(system.file("Rlogo.png", package = "magick"))
#' logo <- image_scale(logo, "400")
#' image_trim(logo)
image_trim <- function(image){
  assert_image(image)
  magick_image_trim(image)
}

#' @export
#' @rdname transformations
#' @examples
#' image_background(logo, "pink", flatten = TRUE)
image_background <- function(image, color, flatten = FALSE){
  assert_image(image)
  out <- magick_image_background(image, color)
  if(isTRUE(flatten)){
    image_flatten(out)
  } else {
    return(out)
  }
}

#' @export
#' @rdname transformations
#' @examples image_crop(logo, "400x400+200+200")
image_crop <- function(image, geometry = ""){
  assert_image(image)
  magick_image_crop(image, geometry)
}

#' @export
#' @rdname transformations
#' @examples image_scale(logo, "200x200")
image_scale <- function(image, geometry = ""){
  assert_image(image)
  magick_image_scale(image, geometry)
}

#' @export
#' @rdname transformations
#' @examples image_sample(logo, "200x200")
image_sample <- function(image, geometry = ""){
  assert_image(image)
  magick_image_sample(image, geometry)
}

#' @export
#' @rdname transformations
#' @param color a valid \href{https://www.imagemagick.org/Magick++/Color.html}{color string}
#' @param geometry a string with \href{https://www.imagemagick.org/Magick++/Geometry.html}{geometry syntax}
#' for example \code{"10x10+5-5"}.
#' @examples image_border(logo, "red", "10x10")
image_border <- function(image, color = "", geometry = ""){
  assert_image(image)
  magick_image_border(image, color, geometry)
}

#' @export
#' @rdname transformations
#' @param noisetype integer betwee 0 and 5 with
#' \href{https://www.imagemagick.org/Magick++/Enumerations.html#NoiseType}{noisetype}.
#' @examples
#' image_noise(logo)
image_noise <- function(image, noisetype = "gaussian"){
  assert_image(image)
  magick_image_noise(image, noisetype)
}

#' @export
#' @rdname transformations
#' @param radius the radius of the Gaussian, in pixels, not counting the center pixel.
#' @param sigma the standard deviation of the Laplacian, in pixels.
#' @examples
#' image_blur(logo, 10, 10)
image_blur <- function(image, radius = 1, sigma = 0.5){
  assert_image(image)
  magick_image_blur(image, radius, sigma)
}

#' @export
#' @rdname transformations
#' @examples
#' image_charcoal(logo)
image_charcoal <- function(image, radius = 1, sigma = 0.5){
  assert_image(image)
  magick_image_charcoal(image, radius, sigma)
}

#' @export
#' @rdname transformations
#' @examples
#' image_edge(logo)
image_edge <- function(image, radius = 1){
  assert_image(image)
  magick_image_edge(image, radius)
}

#' @export
#' @rdname transformations
#' @examples
#' image_oilpaint(logo)
image_oilpaint <- function(image, radius = 1){
  assert_image(image)
  magick_image_oilpaint(image, radius)
}

#' @export
#' @rdname transformations
#' @examples
#' image_emboss(logo)
image_emboss <- function(image, radius = 1, sigma = 0.5){
  assert_image(image)
  magick_image_emboss(image, radius, sigma)
}

#' @export
#' @rdname transformations
#' @examples
#' image_enhance(logo)
image_enhance <- function(image){
  assert_image(image)
  magick_image_enhance(image)
}

#' @export
#' @rdname transformations
#' @examples
#' image_equalize(logo)
image_equalize <- function(image){
  assert_image(image)
  magick_image_equalize(image)
}

#' @export
#' @rdname transformations
#' @examples
#' image_flip(logo)
image_flip <- function(image){
  assert_image(image)
  magick_image_flip(image)
}

#' @export
#' @rdname transformations
#' @examples
#' image_flop(logo)
image_flop <- function(image){
  assert_image(image)
  magick_image_flop(image)
}

# lol this is so ugly it should be illegal
#' @export
#' @rdname transformations
#' @examples
#' image_frame(logo)
image_frame <- function(image, geometry = "25x25+6+6"){
  assert_image(image)
  magick_image_frame(image, geometry)
}

#' @export
#' @rdname transformations
#' @param factor image implode factor (special effect)
#' @examples
#' image_implode(logo)
image_implode <- function(image, factor = 0.5){
  assert_image(image)
  magick_image_implode(image, factor)
}


#' @export
#' @rdname transformations
#' @examples
#' image_negate(logo)
image_negate <- function(image){
  assert_image(image)
  magick_image_negate(image)
}

#' @export
#' @rdname transformations
#' @examples
#' image_normalize(logo)
image_normalize <- function(image){
  assert_image(image)
  magick_image_normalize(image)
}

#' @export
#' @rdname transformations
#' @param degrees how many degrees
#' @examples
#' image_rotate(logo, 45)
image_rotate <- function(image, degrees){
  assert_image(image)
  magick_image_rotate(image, degrees)
}

#' @export
#' @rdname transformations
#' @param point string indicating the flood-fill starting point
#' @param fuzz Colors within this distance are considered equal.
#' Use this option to match colors that are close to the target color in RGB space.
#' I think max distance (from #000000 to #FFFFFF) is 256^3.
#' @examples
#' image_fill(image_flatten(logo), "red")
#' image_fill(image_flatten(logo), "red", fuzz = 25600)
image_fill <- function(image, color, point = "1x1", fuzz = 0){
  assert_image(image)
  magick_image_fill(image, color, point, fuzz)
}

#' @export
#' @rdname transformations
#' @examples
#' image_chop(logo, "100x20")
image_chop <- function(image, geometry){
  assert_image(image)
  stopifnot(is.character(geometry))
  magick_image_chop(image, geometry)
}

#' @export
#' @rdname transformations
#' @param opacity percentage of transparency
#' @examples
#' image_colorize(logo, 50, "red")
image_colorize <- function(image, opacity, color){
  assert_image(image)
  magick_image_colorize(image, opacity, color)
}

#' @export
#' @rdname transformations
#' @param pagesize geometry string with preferred size and location of an image canvas.
#' @param density geometry string with vertical and horizontal resolution in pixels of
#' the image. Specifies an image density when decoding a Postscript or PDF.
image_page <- function(image, pagesize = NULL, density = NULL){
  assert_image(image)
  pagesize <- as.character(pagesize)
  density <- as.character(density)
  magick_image_page(image, pagesize, density)
}

#' @export
#' @rdname transformations
#' @param offset geometry string with offset
#' @param operator string with a
#' \href{https://www.imagemagick.org/Magick++/Enumerations.html#CompositeOperator}{composite operator}.
#' @param composite_image composition image
#' @examples # Compose images using one of many operators
#' oldlogo <- image_read(system.file("Rlogo-old.png", package = "magick"))
#' image_composite(logo, oldlogo)
#' image_composite(logo, oldlogo, operator = "copyred")
#'
image_composite <- function(image, composite_image = image[1], operator = "atop", offset = "0x0"){
  assert_image(image)
  stopifnot(inherits(composite_image, "magick-image"))
  magick_image_composite(image, composite_image, offset, operator)
}

#' @export
#' @rdname transformations
#' @param sharpen enhance intensity differences in image
#' @examples
#' # Lights up the R logo
#' frames <- image_scale(oldlogo, "400x400")
#' for(i in 1:7) frames <- c(frames, image_contrast(frames[i]))
#' (blink <- image_animate(c(frames, rev(frames)), fps = 20, loop = 1))
#'
image_contrast <- function(image, sharpen = 1){
  assert_image(image)
  magick_image_contrast(image, sharpen)
}

#' @export
#' @rdname transformations
#' @param text annotation text
#' @param gravity string with
#' \href{https://www.imagemagick.org/Magick++/Enumerations.html#GravityType}{gravity type}
#' @param location geometry string with location relative to \code{gravity}
#' @param size font-size in pixels
#' @param strokecolor adds a stroke (border around the text)
#' @param boxcolor background color that annotation text is rendered on.
#' @param font rendering font. To use a TrueType font, precede the TrueType filename with an @.
#' @examples # Add some text to an image
#' image_annotate(logo, "This is a test")
#' image_annotate(logo, "CONFIDENTIAL", size = 50, color = "red", boxcolor = "pink",
#'  degrees = 30, location = "+100+100")
#'
#' # Setting fonts requires fontconfig support (and that you have the font)
#' myfont <- ifelse(identical("windows", .Platform$OS.type), "courier-new", "courier")
#' try(image_annotate(logo, "The quick brown fox", font = myfont, size = 50))
image_annotate <- function(image, text, gravity = "northwest", location = "+0+0", degrees = 0,
                           size = 10, font = NULL, color = NULL, strokecolor = NULL, boxcolor = NULL){
  assert_image(image)
  font <- as.character(font)
  size <- as.integer(size)
  color <- as.character(color)
  strokecolor <- as.character(strokecolor)
  boxcolor <- as.character(boxcolor)
  magick_image_annotate(image, text, gravity, location, degrees, size, font, color, strokecolor, boxcolor)
}

#' @export
#' @rdname transformations
#' @param format output format such as \code{png}, \code{jpeg}, \code{gif} or \code{pdf}.
#' Can also be a bitmap type such as \code{rgba} or \code{rgb}.
image_convert <- function(image, format){
  assert_image(image)
  magick_image_format(image, format)
}
