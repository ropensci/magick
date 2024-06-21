#' Set encoder defines
#'
#' So called 'defines' are properties that are passed along to external
#' filters and libraries. Usually defines are used in [image_read] or
#' [image_write] to control the image encoder/decoder, but you can also
#' set these manually on the image object.
#'
#' The defines values must be a character string, where the names contain
#' the defines keys. Each name must be of the format "enc:key" where the
#' first part is the encoder or filter to which the key is passed. For
#' example `"png:...."` defines can control the encoding and decoding of
#' png images.
#'
#' The [image_set_defines] function does not make a copy of the image, so
#' the defined values remain in the image object until they are overwritten
#' or unset.
#'
#' @family image
#' @export
#' @inheritParams editing
#' @param defines a named character vector with extra options to control reading.
#' These are the `-define key{=value}` settings in the [command line tool](http://www.imagemagick.org/script/command-line-options.php#define).
#' Use an empty string for value-less defines, and NA to unset a define.
#' @rdname defines
#' @name defines
#' @examples # Write an image
#' x <- image_read("https://jeroen.github.io/images/frink.png")
#' image_write(x, "frink.png")
#'
#' # Pass some properties to PNG encoder
#' defines <- c("png:compression-filter" = "1", "png:compression-level" = "0")
#' image_set_defines(x, defines)
#' image_write(x, "frink-uncompressed.png")
#'
#' # Unset properties
#' defines[1:2] = NA
#' image_set_defines(x, defines)
#' image_write(x, "frink-final.png")
#'
#' # Compare size and cleanup
#' file.info(c("frink.png", "frink-uncompressed.png", "frink-final.png"))
#' unlink(c("frink.png", "frink-uncompressed.png", "frink-final.png"))
image_set_defines <- function(image, defines){
  assert_image(image)
  validate_defines(defines)
  for(i in seq_along(defines)){
    val <- defines[i]
    nm <- strsplit(names(val), ":", fixed = TRUE)[[1]]
    magick_image_set_define(image, nm[1], nm[2], val)
  }
}

validate_defines <- function(defines){
  if(length(defines)){
    if(!is.character(defines))
      stop("Argument 'defines' must be named character vector")
    nms <- names(defines)
    if(length(unique(nms)) != length(defines))
      stop("Argument 'defines' does not have proper names")
    if(any(vapply(strsplit(nms, ":", fixed = TRUE), length, integer(1)) < 2))
      stop("Each define name must contain a ':' separator")
    return(defines)
  } else {
    return(character())
  }
}
