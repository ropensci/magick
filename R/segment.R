#' Image segmentation
#'
#' Basic image segmentation like connected components labelling, blob extraction and fuzzy c-means
#'
#' - [image_connect] Connect adjacent pixels with the same pixel intensities to do blob extraction
#' - [image_split] Splits the image according to pixel intensities
#' - [image_fuzzycmeans] Fuzzy c-means segmentation of the histogram of color components
#'
#' @name segment
#' @rdname segment
#' @export
#' @details
#' \code{image_connected} does blob extraction by scanning the image, pixel-by-pixel from top-left to bottom-right
#' where regions of adjacent pixels which share the same set of intensity values get combined
#' @inheritParams editing
#' @param connectivity number neighbor colors which are considered part of a unique object
#' @examples
#' img <- image_read("https://www.imagemagick.org/image/objects.gif")
#' img <- image_convert(img, colorspace = "Gray")
#' img
#'
#' # Split image in blobs of connected pixel levels
#' img %>%
#'   image_connect(connectivity = 4) %>%
#'   image_split()
image_connect <- function(image, connectivity = 4){
  assert_image(image)
  connectivity <- as.integer(connectivity)
  stopifnot(connectivity >= 0)
  magick_image_connect(image, connectivity)
}


#' @export
#' @rdname segment
image_split <- function(image){
  assert_image(image)
  pixels <- as.integer(image)
  pixellevels <- as.integer(names(table(pixels)))
  blobs <- lapply(pixellevels, FUN=function(group){
    x <- pixels
    ## if part of the group, set to white, otherwise to black
    x[pixels == group] <- 1
    x[pixels != group] <- 0
    image_read(x)
  })
  blobs <- do.call(image_join, blobs)
  blobs
}


#' @export
#' @rdname segment
#' @param min_pixels the minimum number of pixels contained in a hexahedra before it can be considered valid (expressed as a percentage)
#' @param smoothing the smoothing threshold which eliminates noise in the second derivative of the histogram (higher values gives smoother second derivative)
#' @examples
#'
#' # Fuzzy c-means
#' image_fuzzycmeans(logo)
#'
#' logo %>%
#'   image_convert(colorspace = "HCL") %>%
#'   image_fuzzycmeans(smoothing = 5)
image_fuzzycmeans <- function(image, min_pixels = 1, smoothing = 1.5){
  assert_image(image)
  min_pixels <- as.numeric(min_pixels)
  smoothing <- as.numeric(smoothing)
  magick_image_fuzzycmeans(image, min_pixels, smoothing)
}

