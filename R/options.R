#' Magick Options
#'
#' List option types and values supported in your version of ImageMagick. For
#' descriptions see
#' [ImageMagick Enumerations](https://www.imagemagick.org/Magick++/Enumerations.html).
#'
#' @rdname options
#' @family image
#' @name options
#' @export
#' @references ImageMagick Manual: [Enumerations](https://www.imagemagick.org/Magick++/Enumerations.html)
magick_options <- function(){
  types <- option_types()
  types <- types[types != "Undefined"]
  types <- types[types != "Command"]
  Filter(length, sapply(types, list_options))
}

#' @export
#' @rdname options
option_types <- function(){
  list_options("List")
}

#' @export
#' @rdname options
filter_types <- function(){
  list_options('filter')
}

#' @export
#' @rdname options
metric_types <- function(){
  list_options('metric')
}

#' @export
#' @rdname options
dispose_types <- function(){
  list_options('dispose')
}

#' @export
#' @rdname options
compose_types <- function(){
  list_options('compose')
}

#' @export
#' @rdname options
colorspace_types <- function(){
  list_options('colorspace')
}

#' @export
#' @rdname options
channel_types <- function(){
  list_options('channel')
}

#' @export
#' @rdname options
image_types <- function(){
  list_options('type')
}

#' @export
#' @rdname options
kernel_types <- function(){
  list_options('kernel')
}

#' @export
#' @rdname options
noise_types <- function(){
  list_options('noise')
}

#' @export
#' @rdname options
gravity_types <- function(){
  list_options('gravity')
}

#' @export
#' @rdname options
orientation_types <- function(){
  list_options('orientation')
}

#' @export
#' @rdname options
morphology_types <- function(){
  list_options('morphology')
}

#' @export
#' @rdname options
style_types <- function(){
  list_options('style')
}

#' @export
#' @rdname options
decoration_types <- function(){
  list_options('decoration')
}

#' @export
#' @rdname options
compress_types <- function(){
  list_options('compress')
}

#' @export
#' @rdname options
distort_types <- function(){
  list_options('distort')
}
