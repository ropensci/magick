#' Image Segmentation
#'
#' Basic image segmentation like connected components labelling, blob extraction and fuzzy c-means
#'
#' - [image_connect] Connect adjacent pixels with the same pixel intensities to do blob extraction
#' - [image_split] Splits the image according to pixel intensities
#' - [image_fuzzycmeans] Fuzzy c-means segmentation of the histogram of color components
#'
#' [image_connect] performs blob extraction by scanning the image, pixel-by-pixel from top-left
#' to bottom-right where regions of adjacent pixels which share the same set of intensity values
#' get combined.
#'
#' @name segmentation
#' @rdname segmentation
#' @export
#' @family image
#' @details
#' @inheritParams editing
#' @param connectivity number neighbor colors which are considered part of a unique object
#' @examples # Split an image by color
#' img <- image_quantize(logo, 4)
#' layers <- image_split(img)
#' layers
#'
#' # This returns the original image
#' image_flatten(layers)
#'
#' # From the IM website
#' objects <- image_convert(demo_image("objects.gif"), colorspace = "Gray")
#' objects
#'
#' # Split image in blobs of connected pixel levels
#' if(magick_config()$version > "6.9.0"){
#' objects %>%
#'   image_connect(connectivity = 4) %>%
#'   image_split()
#'
#' # Fuzzy c-means
#' image_fuzzycmeans(logo)
#'
#' logo %>%
#'   image_convert(colorspace = "HCL") %>%
#'   image_fuzzycmeans(smoothing = 5)
#' }
image_connect <- function(image, connectivity = 4){
  assert_image(image)
  connectivity <- as.integer(connectivity)
  stopifnot(connectivity >= 0)
  magick_image_connect(image, connectivity)
}

#' @export
#' @rdname segmentation
#' @param keep_color if TRUE the output images retain the color of the input pixel.
#' If FALSE all matching pixels are set black to retain only the image mask.
image_split <- function(image, keep_color = TRUE){
  assert_image(image)
  pixels <- as.integer(image)
  colors <- sort(unique(c(pixels)))
  blobs <- lapply(colors, function(col){ #-256^3 = solid black
    val <- ifelse(isTRUE(keep_color), col, -16777216L)
    image_read((pixels == col) * val)
  })
  image_join(blobs)
}

#' @export
#' @rdname segmentation
#' @param min_pixels the minimum number of pixels contained in a hexahedra before it can be considered valid (expressed as a percentage)
#' @param smoothing the smoothing threshold which eliminates noise in the second derivative of the histogram (higher values gives smoother second derivative)
image_fuzzycmeans <- function(image, min_pixels = 1, smoothing = 1.5){
  assert_image(image)
  min_pixels <- as.numeric(min_pixels)
  smoothing <- as.numeric(smoothing)
  magick_image_fuzzycmeans(image, min_pixels, smoothing)
}
