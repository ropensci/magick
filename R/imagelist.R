#' Image List
#'
#' Create and manipulate sequences of images, for example to generate animation.
#'
#' @export
#' @rdname imagelist
#' @param imagelist vector of images. Each element is passed to \link{image_read}.
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
#' animation <- imagelist_read(images)
#' imagelist_write(animation, path = "out.gif")
imagelist_read <- function(imagelist){
  if(inherits(imagelist, "magick-image-list")){
    return(imagelist)
  }
  stopifnot(is.character(imagelist) || is.list(imagelist))
  imagelist <- lapply(imagelist, image_read)
  magick_imagelist_create(imagelist)
}

#' @export
#' @rdname imagelist
imagelist_write <- function(imagelist, format = "gif", delay = 100, path = NULL){
  imagelist <- imagelist_read(imagelist)
  buf <- magick_imagelist_write(imagelist, format, delay)
  if(is.character(path)){
    writeBin(buf, path)
    return(path)
  }
  return(buf)
}

#' @export
"print.magick-image-list" <- function(x, ...){
  viewer <- getOption("viewer")
  if(is.function(viewer)){
    tmp <- file.path(tempdir(), "preview.gif")
    imagelist_write(x, format = "gif", path = tmp)
    viewer(tmp)
  }
  NextMethod()
}
