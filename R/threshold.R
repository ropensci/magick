#' Image thresholding
#'
#' Thresholding an image can be used for simple and straightforward image segmentation.
#' The function [image_threshold()] allows to do black and white thresholding whereas
#' [image_lat()] performs local adaptive thresholding.
#'
#'  - `image_threshold(type = "black")`: Forces all pixels below the threshold into black while leaving all pixels
#' at or above the threshold unchanged
#'  - `image_threshold(type = "white")`: Forces all pixels above the threshold into white while leaving all pixels
#' at or below the threshold unchanged
#'  - `image_lat()`: Local Adaptive Thresholding. Looks in a box (width x height) around the
#' pixel neighborhood if the pixel value is bigger than the average minus an offset.
#'
#' @export
#' @name thresholding
#' @rdname thresholding
#' @inheritParams editing
#' @param type type of thresholding, either one of lat, black or white (see details below)
#' @param threshold pixel intensity threshold percentage for black or white thresholding
#' @param channel a value of [channel_types()] specifying which channel(s) to set
#' @examples
#' test <- image_convert(logo, colorspace = "Gray")
#' image_threshold(test, type = "black", threshold = "50%")
#' image_threshold(test, type = "white", threshold = "50%")
#'
#' # Turn image into BW
#' test %>%
#'   image_threshold(type = "white", threshold = "50%") %>%
#'   image_threshold(type = "black", threshold = "50%")
#'
#' # adaptive thresholding
#' image_lat(test, geometry = '10x10+5%')
image_threshold <- function(image, type = c("black", "white"), threshold = "50%", channel = NULL){
  type <- match.arg(type)
  assert_image(image)
  if(type == "black"){
    magick_image_threshold_black(image, as.character(threshold), as.character(channel))
  } else {
    magick_image_threshold_white(image, as.character(threshold), as.character(channel))
  }
}

#' @export
#' @rdname thresholding
#' @param black_point value between 0 and 100, the darkest color in the image
#' @param white_point value between 0 and 100, the lightest color in the image
#' @param mid_point value between 0 and 10 used for gamma correction
image_level <- function(image, black_point = 0, white_point = 100, mid_point = 1, channel = NULL){
  assert_image(image)
  black_point <- as.numeric(black_point)
  white_point <- as.numeric(white_point)
  mid_point <- as.numeric(mid_point)
  channel <- as.character(channel)
  magick_image_level(image, black_point, white_point, mid_point, channel)
}

#' @export
#' @rdname thresholding
#' @param geometry pixel window plus offset for LAT algorithm
image_lat <- function(image, geometry = '10x10+5%'){
  assert_image(image)
  magick_image_lat(image, geometry)
}
