#' Create Animation
#'
#' Creates an animation out of a series of images.
#'
#' @export
#' @param images list of images (URLs or raw vectors)
#' @param format output format which supports animations
#' @param delay time in 1/100ths of a second (0 to 65535) which must expire before displaying
#' the next image in an animated sequence.
#' @examples
#' images <- sapply(1:5, function(i){
#'   png(tmp <- tempfile(), width = 800, height = 600)
#'   par(ask = FALSE)
#'   plot(rnorm(100))
#'   dev.off()
#'   return(tmp)
#' })
#' gif_file <- image_animate(images, "gif")
#' viewer <- getOption("viewer", browseURL)
#' viewer(gif_file)
image_animate <- function(images, format = "gif", delay = 100){
  stopifnot(is.character(images) || is.list(images))
  input <- lapply(images, read_image)
  output <- animate(input, format, delay)
  write_image(output, images[[1]], format)
}
