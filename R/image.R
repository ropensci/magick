#' Image Manipulation
#'
#' Read, write and edit images. All image functions are vectorized, meaning
#' they can operate either on a single frame or a series of frames (e.g. to
#' work with video or animation).
#'
#' @export
#' @aliases image magick imagemagick
#' @rdname image
#' @param path file path, URL, or raw vector with image data
#' @param image object returned by \code{image_read}
#' @param format output format such as \code{png}, \code{jpeg}, \code{gif} or \code{pdf}.
#' @param color a valid \href{https://www.imagemagick.org/Magick++/Color.html}{color string}
#' @param delay time in 1/100ths of a second (0 to 65535) which must expire before displaying
#' the next image in an animated sequence.
#' @param geometry a string with \href{https://www.imagemagick.org/Magick++/Geometry.html}{geometry syntax}
#' for example \code{"10x10+5-5"}.
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
#' @rdname image
image_format <- function(image, format){
  stopifnot(inherits(image, "magick-image"))
  magick_image_format(image, format)
}

#' @export
#' @rdname image
image_delay <- function(image, delay){
  stopifnot(inherits(image, "magick-image"))
  magick_image_delay(image, delay)
}

#' @export
#' @rdname image
image_trim <- function(image){
  stopifnot(inherits(image, "magick-image"))
  magick_image_trim(image)
}

#' @export
#' @rdname image
image_border <- function(image, color = "", geometry = ""){
  stopifnot(inherits(image, "magick-image"))
  magick_image_border(image, color, geometry)
}

#' @export
#' @rdname image
image_write <- function(image, path = NULL){
  stopifnot(inherits(image, "magick-image"))
  buf <- magick_image_write(image)
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
    tmp <- file.path(tempdir(), "preview.gif")
    image_write(x, path = tmp)
    viewer(tmp)
  }
  NextMethod()
}

#' @export
"[.magick-image" <- function(x, i){
  stopifnot(inherits(x, "magick-image"))
  magick_image_subset(x, i)
}

#' @export
"[[.magick-image" <- function(x, i){
  stopifnot(inherits(x, "magick-image"))
  stop("not yet implemented")
  #magick_image_frame(x, i)
}

#' @export
"c.magick-image" <- function(...){
  x <- unlist(list(...))
  stopifnot(all(vapply(x, inherits, logical(1), "magick-image")))
  magick_image_join(x)
}

#' @export
"length.magick-image" <- function(x){
  stopifnot(inherits(x, "magick-image"))
  magick_image_length(x)
}

# @export
"as.list.magick-image" <- function(...){
  cat("This will convert to a list of frames\n")
  stop("as.list() not yet implemented")
}


image_create <- function(image){
  if(inherits(image, "magick-image")){
    return(image)
  }
  stopifnot(is.character(image) || is.list(image))
  image <- lapply(image, frame_read)
  magick_image_create(image)
}

