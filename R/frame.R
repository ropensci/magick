#' Magick Frames
#'
#' A frame is a single slice of an frame.
#'
#' @importFrom Rcpp sourceCpp
#' @param frame magick-frame object, file path or raw vector with frame data
#' @param format output format, e.g. \code{jpeg}, \code{png}, \code{pdf} or \code{gif}.
#' @param path file to write output. Use \code{NULL} to return as raw vector.
#' @useDynLib magick
#' @export
#' @rdname magick_frame
#' @references frameMagick documentation: \url{https://www.framemagick.org/Magick++/image++.html}
#' @examples png_file <- tempfile(fileext = ".png")
#' png(png_file)
#' plot(cars)
#' dev.off()
#' frame <- frame_read(png_file)
#' frame_info(frame)
#' frame_write(frame, "jpg", "output.jpg")
#' frame_write(frame, "gif", "output.gif")
#' frame_write(frame, "pdf", "output.pdf")
#' frame_write(frame, "tiff", "output.tiff")
frame_read <- function(frame){
  if(inherits(frame, "magick-frame")){
    return(frame)
  }
  if(is.character(frame)){
    frame <- normalizePath(frame, mustWork = TRUE)
    frame <- readBin(frame, raw(), file.info(frame)$size)
  }
  if(!is.raw(frame)){
    stop("Parameter 'frame' must be an frame object, file path or raw vector with frame data")
  }
  magick_frame_read(frame)
}

#' @export
#' @rdname magick_frame
frame_write <- function(frame, format, path = NULL){
  buf <- magick_frame_write(frame_read(frame), format)
  if(is.character(path)){
    writeBin(buf, path)
    return(path)
  }
  return(buf)
}

#' @export
#' @rdname magick_frame
frame_info <- function(frame){
  magick_frame_info(frame_read(frame))
}

#' @export
"print.magick-frame" <- function(x, ...){
  info <- frame_info(x)
  viewer <- getOption("viewer")
  if(is.function(viewer)){
    tmp <- file.path(tempdir(), "preview.jpg")
    frame_write(x, format = "jpg", path = tmp)
    viewer(tmp)
  }
  NextMethod()
}
