#' Image thresholding
#'
#' Thresholding an image can be used for simple and straightforward image segmentation.
#' The function \code{image_threshold} allows to do black thresholding, white thresholding
#' as well as local adaptive thresholding.
#' @export
#' @name image_threshold
#' @rdname image_threshold
#' @inheritParams editing
#' @param type type of thresholding, either one of lat, black or white (see details below)
#' @param threshold pixel intensity threshold percentage for black or white thresholding
#' @param geometry pixel window plus offset for LAT algorithm
#' @details
#'  - type = black: Forces all pixels below the threshold into black while leaving all pixels at or above the threshold unchanged
#'  - type = white: Forces all pixels above the threshold into white while leaving all pixels at or below the threshold unchanged
#'  - type = lat: Local Adaptive Thresholding. Looks in a box (width x height) around the pixel neighborhood if the pixel value is bigger than the average minus an offset
#' @examples
#' logo <- image_read("logo:")
#' logo <- image_convert(logo, colorspace = "Gray")
#' image_threshold(logo, type = "lat", geometry = "5x5+10")
#' image_threshold(logo, type = "black", threshold = "50%")
#' image_threshold(logo, type = "white", threshold = "50%")
#'
#' image_threshold(logo, type = "white", threshold = "50%") %>%
#'   image_threshold(logo, type = "black", threshold = "50%")
image_threshold <- function(image, type = c("lat", "black", "white"), geometry = '5x5+2%', threshold = "50%"){
  type <- match.arg(type)
  assert_image(image)
  if(type == "lat"){
    magick_image_lat(image, geometry)
  }else if(type == "black"){
    magick_image_threshold_black(image, as.character(threshold))
  }else if(type == "white"){
    magick_image_threshold_white(image, as.character(threshold))
  }
}

