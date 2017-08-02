#' Apply a Function over Image Frames
#'
#' \code{image_apply} calls a transformation function to each frame of the image and
#' joints the result back into a single image. Because most operations are already
#' vectorized this is often not needed. Note that \code{FUN} should return an image.
#' To apply other kinds of functions simply use \link{lapply} or \link{vapply}, etc.
#'
#' @rdname apply
#' @export
#' @inheritParams editing
#' @param FUN a function to be called on each frame in the image
#' @param ... additional parameters for \code{FUN}
image_apply <- function(image, FUN, ...){
  assert_image(image)
  out <- lapply(image, FUN, ...)
  if(!all(sapply(out, inherits, "magick-image")))
    stop("Function %s did not return a valid image")
  image_join(out)
}
