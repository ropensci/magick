#' Magick Configuration
#'
#' ImageMagick can be configured to support various additional tool and formats
#' via external libraries. These funtions show which features ImageMagick supports
#' on your system.
#'
#' Note that \code{coder_info} raises an error for unsupported formats.
#'
#' @export
#' @rdname config
#' @param format image format such as \code{png}, \code{tiff} or \code{pdf}.
#' @references \url{https://www.imagemagick.org/Magick++/CoderInfo.html}
#' @examples coder_info("png")
#' coder_info("jpg")
#' coder_info("pdf")
#' coder_info("tiff")
#' coder_info("gif")
coder_info <- function(format){
  magick_coder_info(format)
}

#' @rdname config
#' @export
magick_config <- function(){
  magick_config_internal()
}
