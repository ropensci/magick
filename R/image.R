#' Magick Images
#'
#' Converts image to another format.
#'
#' @importFrom Rcpp sourceCpp
#' @param image magick-image object, file path or raw vector with image data
#' @param format output format, e.g. \code{jpeg}, \code{png}, \code{pdf} or \code{gif}.
#' @param path file to write output. Use \code{NULL} to return as raw vector.
#' @useDynLib magick
#' @export
#' @rdname magick_image
#' @references ImageMagick documentation: \url{https://www.imagemagick.org/Magick++/Image++.html}
#' @examples png_file <- tempfile(fileext = ".png")
#' png(png_file)
#' plot(cars)
#' dev.off()
#' image <- image_read(png_file)
#' image_info(image)
#' image_write(image, "jpg", "output.jpg")
#' image_write(image, "gif", "output.gif")
#' image_write(image, "pdf", "output.pdf")
#' image_write(image, "tiff", "output.tiff")
image_read <- function(image){
  if(inherits(image, "magick-image")){
    return(image)
  }
  if(is.character(image)){
    image <- normalizePath(image, mustWork = TRUE)
    image <- readBin(image, raw(), file.info(image)$size)
  }
  if(!is.raw(image)){
    stop("Parameter 'image' must be an image object, file path or raw vector with image data")
  }
  magick_image_read(image)
}

#' @export
#' @rdname magick_image
image_write <- function(image, format, path = NULL){
  buf <- magick_image_write(image_read(image), format)
  if(is.character(path)){
    writeBin(buf, path)
    return(path)
  }
  return(buf)
}

#' @export
#' @rdname magick_image
image_info <- function(image){
  magick_image_info(image_read(image))
}

#' @export
"print.magick-image" <- function(x, ...){
  info <- image_info(x)
  viewer <- getOption("viewer")
  if(is.function(viewer)){
    tmp <- file.path(tempdir(), "preview.jpg")
    image_write(x, format = "jpg", path = tmp)
    viewer(tmp)
  }
  NextMethod()
}
