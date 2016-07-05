#' Create Animation
#'
#' Creates an animation out of a series of images.
#'
#' @export
#' @param images list of images (URLs or raw vectors)
#' @param format output format which supports animations
#' @param delay time in 1/100ths of a second (0 to 65535) which must expire before displaying
#' the next image in an animated sequence. Length must be 1 or equal length of \code{images}.
#' @param path file to write output. Use \code{NULL} to return as raw vector.
#' @examples
#' images <- sapply(1:5, function(i){
#'   png(tmp <- tempfile(), width = 800, height = 600)
#'   par(ask = FALSE)
#'   plot(rnorm(100))
#'   dev.off()
#'   return(tmp)
#' })
#' gif_file <- image_animate(images, "gif", path = tempfile())
#' viewer <- getOption("viewer", browseURL)
#' viewer(gif_file)
image_animate <- function(images, format = "gif", delay = 100, path = NULL){
  stopifnot(is.character(images) || is.list(images))
  input <- lapply(images, image_read)
  if(length(delay == 1))
    delay <- rep(delay, length(input))
  buf <- magick_image_animage(input, format, delay)
  if(is.character(path)){
    writeBin(buf, path)
    return(path)
  }
  return(buf)
}
