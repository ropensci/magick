#' Image
#'
#' Create and manipulate sequences of images, for example to generate animation.
#'
#' @export
#' @rdname image
#' @param image vector of images. Each element is passed to \link{image_read}.
#' @param format output format which supports animations
#' @param delay time in 1/100ths of a second (0 to 65535) which must expire before displaying
#' the next image in an animated sequence.
#' @param path file to write output. Use \code{NULL} to return as raw vector.
#' @examples
#' images <- sapply(1:5, function(i){
#'   png(tmp <- tempfile(), width = 800, height = 600)
#'   par(ask = FALSE)
#'   plot(rnorm(100))
#'   dev.off()
#'   return(tmp)
#' })
#' animation <- image_create(images)
#' image_write(animation, path = "out.gif")
image_create <- function(image){
  if(inherits(image, "magick-image")){
    return(image)
  }
  stopifnot(is.character(image) || is.list(image))
  image <- lapply(image, frame_read)
  magick_image_create(image)
}

#' @export
#' @rdname  image
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
#' @rdname image
image_write <- function(image, format = "gif", delay = 100, path = NULL){
  image <- image_create(image)
  buf <- magick_image_write(image, format, delay)
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
    image_write(x, format = "gif", path = tmp)
    viewer(tmp)
  }
  NextMethod()
}

#' @export
"[.magick-image" <- function(i, j){
  stop("[ not yet implemented")
}

#' @export
"[[.magick-image" <- function(i, j){
  stop("[[ not yet implemented")
}

#' @export
"c.magick-image" <- function(...){
  stop("c() not yet implemented")
}

