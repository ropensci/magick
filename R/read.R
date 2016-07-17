#' Image Manipulation
#'
#' Read, write and edit images. All image functions are vectorized, meaning
#' they can operate either on a single frame or a series of frames (e.g. to
#' create a collage, video, or animation).
#'
#' @export
#' @family image
#' @rdname image-read
#' @name image-read
#' @param path file path, URL, or raw vector with image data
#' @param image object returned by \code{image_read}
#' @references Magick++ Image STL: \url{https://www.imagemagick.org/Magick++/STL.html}
#' @examples
#' # Download image from the web
#' frink <- image_read("https://jeroenooms.github.io/images/frink.png")
#' frink2 <- image_crop(frink)
#' image_write(frink2, "output.png")
image_read <- function(path){
  if(is.character(path)){
    buflist <- lapply(path, read_path)
    magick_image_read_list(buflist)
  } else {
    buf <- read_path(path)
    magick_image_read(buf)
  }
}

#' @export
#' @inheritParams image-manipulate
#' @rdname image-read
image_write <- function(image, path = NULL, format = NULL){
  stopifnot(inherits(image, "magick-image"))
  if(!length(image))
    warning("Writing image with 0 frames")
  if(length(format)){
    image <- image_format(image, format)
  }
  buf <- magick_image_write(image)
  if(is.character(path)){
    writeBin(buf, path)
    return(path)
  }
  return(buf)
}

#' @description Append a sequence of image frames left-to-right or top-to-bottom
#' using \code{image_append}.
#' @export
#' @rdname image-read
#' @param stack place images top-to-bottom (TRUE) or left-to-right (FALSE)
#' @examples
#' # Create thumbnails from GIF
#' banana <- image_read(system.file("banana.gif", package = "magick"))
#' length(banana)
#' image_average(banana)
#' image_flatten(banana)
#' image_append(banana)
#' image_append(banana, stack = TRUE)
#'
#' # Append images together
#' image_append(image_scale(c(image_append(banana[c(1,3)], stack = TRUE), frink)))
image_append <- function(image, stack = FALSE){
  stopifnot(inherits(image, "magick-image"))
  magick_image_append(image, stack)
}

#' @export
#' @rdname image-read
image_average <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_average(image)
}

#' @export
#' @rdname image-read
image_coalesce <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_coalesce(image)
}

#' @export
#' @rdname image-read
image_flatten <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_flatten(image)
}

#' @export
#' @rdname image-read
image_fft <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_fft(image)
}

#' @export
#' @rdname image-read
#' @param map_image reference image to map colors from
#' @param dither set TRUE to enable dithering
image_map <- function(image, map_image, dither = FALSE){
  stopifnot(inherits(image, "magick-image"))
  stopifnot(inherits(map_image, "magick-image"))
  magick_image_map(image, map_image, dither)
}

#' @export
#' @rdname image-read
image_montage <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_montage(image)
}

#' @export
#' @rdname image-read
#' @examples
#' # Combine with another image
#' logo <- image_read(system.file("Rlogo.png", package = "magick"))
#' oldlogo <- image_read(system.file("Rlogo-old.png", package = "magick"))
#'
#' # Create morphing animation
#' both <- image_scale(c(oldlogo, logo), "400x400")
#' image_average(image_crop(c(oldlogo, logo)))
#' animation <- image_morph(both, 10)
#' image_format(animation, "gif")
#' @param frames number of frames to use in output animation
image_morph <- function(image, frames){
  stopifnot(inherits(image, "magick-image"))
  stopifnot(is.numeric(frames))
  magick_image_morph(image, frames)
}

#' @export
#' @rdname image-read
image_mosaic <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_mosaic(image)
}
