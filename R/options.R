#' Magick Options
#'
#' List option types and option values supported in your version of ImageMagick. For
#' details about each options see
#' [ImageMagick Enumerations](https://www.imagemagick.org/Magick++/Enumerations.html).
#'
#' @rdname options
#' @name options
#' @references ImageMagick Manual: [Enumerations](https://www.imagemagick.org/Magick++/Enumerations.html)
#' @export
#' @param type a string with any of the `option_types()`
#' @examples # Check possible values:
#' option_values("Compose")
#' option_values("Morphology")
option_values <- function(type){
  stopifnot(is.character(type))
  list_options(type)
}

#' @export
#' @rdname options
option_types <- function(){
  option_values("List")
}

#' @export
#' @rdname options
option_dump <- function(){
  types <- option_types()
  types <- types[types != "Undefined"]
  out <- lapply(types, option_values)
  structure(out, names = types)
}
