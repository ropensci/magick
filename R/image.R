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
#' @examples png_file <- tempfile(fileext = ".png")
#' png(png_file)
#' plot(cars)
#' dev.off()
#' image_write(png_file, "jpg")
#' image_write(png_file, "gif")
#' image_write(png_file, "pdf")
#' image_write(png_file, "tiff")
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
"print.magick-image" <- function(x, ...){
  viewer <- getOption("viewer")
  if(is.function(viewer)){
    tmp <- file.path(tempdir(), "preview.jpg")
    try({
      image_write(x, "jpg", tmp)
      viewer(tmp)
    }, silent = FALSE) # Change to TRUE in production
  }
  NextMethod()
}
