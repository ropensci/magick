#' Image Manipulation
#'
#' Read, write and edit images. All image functions are vectorized, meaning
#' they can operate either on a single frame or a series of frames (e.g. to
#' create a collage, video, or animation).
#'
#' @export
#' @family image
#' @rdname image-stl
#' @name image-stl
#' @param path file path, URL, or raw vector with image data
#' @param image object returned by \code{image_read}
#' @references Magick++ Image STL: \url{https://www.imagemagick.org/Magick++/STL.html}
#' @examples library(magrittr)
#' img <- image_read("https://jeroenooms.github.io/images/frink.png")
#' print(img)
#'
#' # trim whitespace and add a border
#' img %>% image_trim() %>% image_border("blue", "6x6+0+0")
#'
#' # trim off the border again
#' img %>% image_trim()
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
#' @rdname image-stl
#' @param stack if false, rectangular image frames are stacked left-to-right otherwise top-to-bottom.
image_append <- function(image, stack = FALSE){
  stopifnot(inherits(image, "magick-image"))
  magick_image_append(image, stack)
}

#' @export
#' @rdname image-stl
image_write <- function(image, path = NULL){
  stopifnot(inherits(image, "magick-image"))
  buf <- magick_image_write(image)
  if(is.character(path)){
    writeBin(buf, path)
    return(path)
  }
  return(buf)
}
