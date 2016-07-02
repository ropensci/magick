#' Convert Image
#'
#' Converts image to another format.
#'
#' @importFrom Rcpp sourceCpp
#' @param image file path or raw vector to input image
#' @param to output format, e.g. \code{jpeg}, \code{png}, etc
#' @useDynLib magick
#' @export
#' @examples png_file <- tempfile(fileext = ".png")
#' png(png_file)
#' plot(cars)
#' dev.off()
#' image_convert(png_file)
image_convert <- function(image, to = "jpg"){
  stopifnot(is.character(to))
  if(is.character(image)){
    image <- normalizePath(image, mustWork = TRUE)
    input <- readBin(image, raw(), file.info(image)$size)
  } else if(is.raw(image)) {
    input <- image
  } else {
    stop("Parameter 'image' must be file path or raw vector with image data")
  }
  output <- convert_to(input, to)
  if(is.character(image)){
    outfile <- paste0(sub("\\.[a-zA-Z]+$", "", image), ".", to)
    writeBin(output, outfile)
    return(outfile)
  } else {
    return(output)
  }
}
