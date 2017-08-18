#' Animation and Frames
#'
#' Operations specifically for images with multiple frames.
#'
#' @export
#' @inheritParams editing
#' @rdname animation
#' @name animation
#' @family image
#' @param dispose frame disposal method. See
#' \href{http://www.imagemagick.org/Usage/anim_basics/}{documentation}
#' @param fps frames per second
#' @param loop how many times to repeat the animation. Default is infinite.
image_animate <- function(image, fps = 10, loop = 0, dispose = c("background", "previous", "none")){
  assert_image(image)
  stopifnot(is.numeric(fps))
  stopifnot(is.numeric(loop))
  if(100 %% fps)
    stop("argument 'fps' must be a factor of 100")
  delay <- as.integer(100/fps)
  dispose <- match.arg(dispose)
  magick_image_animate(image, delay, as.integer(loop), dispose)
}

#' \code{image_apply} calls a transformation function to each frame of the image and
#' joints the result back into a single image. Because most operations are already
#' vectorized this is often not needed. Note that \code{FUN} should return an image.
#' To apply other kinds of functions simply use \link{lapply} or \link{vapply}, etc.
#'
#' @rdname animation
#' @export
#' @param FUN a function to be called on each frame in the image
#' @param ... additional parameters for \code{FUN}
image_apply <- function(image, FUN, ...){
  assert_image(image)
  out <- lapply(image, FUN, ...)
  if(!all(sapply(out, inherits, "magick-image")))
    stop("Function %s did not return a valid image")
  image_join(out)
}

#' @export
#' @rdname animation
image_mosaic <- function(image, operator = NULL){
  assert_image(image)
  operator <- as.character(operator)
  magick_image_mosaic(image, operator)
}

#' @export
#' @rdname animation
image_montage <- function(image){
  assert_image(image)
  magick_image_montage(image)
}

#' @export
#' @rdname animation
#' @examples
#' # Combine with another image
#' logo <- image_read("https://www.r-project.org/logo/Rlogo.png")
#' oldlogo <- image_read("https://developer.r-project.org/Logo/Rlogo-3.png")
#'
#' # Create morphing animation
#' both <- image_scale(c(oldlogo, logo), "400")
#' image_average(image_crop(both))
#' image_animate(image_morph(both, 10))
#' @param frames number of frames to use in output animation
image_morph <- function(image, frames){
  assert_image(image)
  stopifnot(is.numeric(frames))
  magick_image_morph(image, frames)
}


#' @export
#' @inheritParams composite
#' @rdname animation
image_flatten <- function(image, operator = NULL){
  assert_image(image)
  operator <- as.character(operator)
  magick_image_flatten(image, operator)
}

#' @export
#' @rdname animation
image_average <- function(image){
  assert_image(image)
  magick_image_average(image)
}

#' @export
#' @rdname animation
#' @param stack place images top-to-bottom (TRUE) or left-to-right (FALSE)
#' @examples
#' # Create thumbnails from GIF
#' banana <- image_read("https://jeroen.github.io/images/banana.gif")
#' length(banana)
#' image_average(banana)
#' image_flatten(banana)
#' image_append(banana)
#' image_append(banana, stack = TRUE)
#'
#' # Append images together
#' wizard <- image_read("wizard:")
#' image_append(image_scale(c(image_append(banana[c(1,3)], stack = TRUE), wizard)))
#'
#' image_composite(banana, image_scale(logo, "300"))
#'
#' # Break down and combine frames
#' front <- image_scale(banana, "300")
#' background <- image_background(image_scale(logo, "400"), 'white')
#' frames <- image_apply(front, function(x){image_composite(background, x, offset = "+70+30")})
#' image_animate(frames, fps = 10)
image_append <- function(image, stack = FALSE){
  assert_image(image)
  magick_image_append(image, stack)
}

#' @export
#' @rdname animation
image_coalesce <- function(image){
  assert_image(image)
  magick_image_coalesce(image)
}

