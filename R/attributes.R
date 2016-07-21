#' Image Attributes
#'
#' Functions to get or set Image attributes. Attributes typically do not
#' alter the image itself, but can affect how images get rendered or transformed.
#' Each function modifies the image in place and returns a vector with current
#' attribute values.
#'
#' @export
#' @rdname attributes
#' @inheritParams editing
#' @inheritParams transformations
#' @param antialias Control antialiasing of TrueType fonts (TRUE/FALSE)
image_attr_antialias <- function(image, antialias = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_antialias(image, as.logical(antialias))
}

#' @export
#' @rdname attributes
#' @param delay time in 1/100ths of a second (0 to 65535) which must expire before
#' displaying the next image in an animated sequence.
image_attr_animationdelay <- function(image, delay = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_animationdelay(image, as.integer(delay))
}

#' @export
#' @rdname attributes
image_attr_backgroundcolor <- function(image, color = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_backgroundcolor(image, as.character(color))
}

#' @export
#' @rdname attributes
image_attr_boxcolor <- function(image, color = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_boxcolor(image, as.character(color))
}

#' @export
#' @rdname attributes
#' @param geometry Vertical and horizontal resolution for reading PDF. Defaults is \code{"72x72"}
image_attr_density <- function(image, geometry = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_density(image, as.character(geometry))
}

#' @export
#' @rdname attributes
image_attr_fillcolor <- function(image, color = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_fillcolor(image, as.character(color))
}

#' @export
#' @rdname attributes
#' @param font Text rendering font. To use a TrueType font, precede the TrueType filename with an @.
image_attr_font <- function(image, font = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_font(image, as.character(font))
}

#' @export
#' @rdname attributes
#' @param fontsize Text rendering font point size
image_attr_fontsize <- function(image, fontsize = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_fontsize(image, as.integer(fontsize))
}

#' @export
#' @rdname attributes
#' @param method one of: 0 (unspecified) 1 (do not dispose), 3 (overwrite with background color)
#' or 4 (overwrite with previous graphic.
image_attr_gifmethod <- function(image, method = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_gifmethod(image, as.integer(method))
}

#' @export
#' @rdname attributes
#' @param label string with image label
image_attr_label <- function(image, label = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_label(image, as.character(label))
}

#' @export
#' @rdname attributes
#' @param format string with image format such as \code{png}, \code{gif}, etc.
image_attr_format <- function(image, format = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_format(image, as.character(format))
}

#' @export
#' @rdname attributes
#' @param matte if the image has transparency (TRUE/FALSE).
image_attr_matte <- function(image, matte = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_matte(image, as.logical(matte))
}

#' @export
#' @rdname attributes
image_attr_mattecolor <- function(image, color = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_mattecolor(image, as.character(color))
}

#' @export
#' @rdname attributes
image_attr_pencolor <- function(image, color = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_pencolor(image, as.character(color))
}

#' @export
#' @rdname attributes
#' @param quality JPEG/MIFF/PNG compression level (default 75)
image_attr_quality <- function(image, quality = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_quality(image, as.integer(quality))
}

#' @export
#' @rdname attributes
#' @param quantize Preferred number of colors in the image. The actual number of colors '
#' in the image may be less than your request, but never more.
image_attr_quantize <- function(image, quantize = NULL){
  stopifnot(inherits(image, "magick-image"))
  magick_attr_quantize(image, as.integer(quantize))
}

