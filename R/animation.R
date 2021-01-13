#' Image Frames and Animation
#'
#' Operations to manipulate or combine multiple frames of an image. Details below.
#'
#' For details see [Magick++ STL](https://www.imagemagick.org/Magick++/STL.html)
#' documentation. Short descriptions:
#'
#'  - [image_animate] coalesces frames by playing the sequence and converting to `gif` format.
#'  - [image_morph] expands number of frames by interpolating intermediate frames to blend
#'  into each other when played as an animation.
#'  - [image_mosaic] inlays images to form a single coherent picture.
#'  - [image_montage] creates a composite image by combining frames.
#'  - [image_flatten] merges frames as layers into a single frame using a given operator.
#'  - [image_average] averages frames into single frame.
#'  - [image_append] stack images left-to-right (default) or top-to-bottom.
#'  - [image_apply] applies a function to each frame
#'
#' The [image_apply] function calls an image function to each frame and joins
#' results back into a single image. Because most operations are already vectorized
#' this is often not needed. Note that `FUN()` should return an image. To apply other
#' kinds of functions to image frames simply use [lapply], [vapply], etc.
#'
#' @export
#' @inheritParams editing
#' @rdname animation
#' @name animation
#' @family image
#' @aliases image_coalesce
#' @param dispose a frame [disposal method](https://legacy.imagemagick.org/Usage/anim_basics/#dispose)
#' from [dispose_types()][dispose_types]
#' @param fps frames per second. Ignored if `delay` is not `NULL`.
#' @param delay delay after each frame, in 1/100 seconds.
#' Must be length 1, or number of frames. If specified, then `fps` is ignored.
#' @param loop how many times to repeat the animation. Default is infinite.
#' @param optimize optimize the `gif` animation by storing only the differences
#' between frames. Input images must be exactly the same size.
image_animate <- function(image, fps = 10, delay = NULL, loop = 0,
                          dispose = c("background", "previous", "none"),
                          optimize = FALSE){
  assert_image(image)
  stopifnot(is.numeric(fps))
  stopifnot(is.null(delay) || (
    is.numeric(delay) && length(delay) %in% c(1, length(image))))
  stopifnot(is.numeric(loop))
  stopifnot(is.logical(optimize))
  if(is.null(delay)) {
    if(100 %% fps)
      stop("argument 'fps' must be a factor of 100")
    delay <- 100/fps
  }
  dispose <- match.arg(dispose)
  magick_image_animate(image, as.integer(delay), as.integer(loop), dispose,
                       optimize)
}

image_coalesce <- image_animate

#' @export
#' @rdname animation
#' @param frames number of frames to use in output animation
#' @examples
#' # Combine images
#' logo <- image_read("https://jeroen.github.io/images/Rlogo.png")
#' oldlogo <- image_read("https://jeroen.github.io/images/Rlogo-old.png")
#'
#' # Create morphing animation
#' both <- image_scale(c(oldlogo, logo), "400")
#' image_average(image_crop(both))
#' image_animate(image_morph(both, 10))
#'
image_morph <- function(image, frames = 8){
  assert_image(image)
  stopifnot(is.numeric(frames))
  magick_image_morph(image, frames)
}

#' @export
#' @rdname animation
#' @inheritParams composite
image_mosaic <- function(image, operator = NULL){
  assert_image(image)
  operator <- as.character(operator)
  magick_image_mosaic(image, operator)
}

#' @export
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

#' @rdname animation
#' @export
#' @param FUN a function to be called on each frame in the image
#' @param ... additional parameters for \code{FUN}
image_apply <- function(image, FUN, ...){
  assert_image(image)
  out <- lapply(image, FUN, ...)
  if(!all(vapply(out, inherits, logical(1), what = "magick-image")))
    stop(sprintf("Function %s did not return a valid image.", deparse(substitute(FUN))))
  image_join(out)
}

#' @export
#' @rdname animation
#' @param geometry a [geometry][geometry] string that defines the size the individual
#' thumbnail images, and the spacing between them.
#' @param tile a [geometry][geometry] string for example "4x5 with limits on how the
#' tiled images are to be laid out on the final result.
#' @param gravity a gravity direction, if the image is smaller than the frame, where
#'in the frame is the image to be placed.
#' @param bg a background color string
#' @param shadow enable shadows between images
#' @examples # Simple 4x3 montage
#' input <- rep(logo, 12)
#' image_montage(input, geometry = 'x100+10+10', tile = '4x3', bg = 'pink', shadow = TRUE)
#'
#' # With varying frame size
#' input <- c(wizard, wizard, logo, logo)
#' image_montage(input, tile = '2x2', bg = 'pink', gravity = 'southwest')
image_montage <- function(image, geometry = NULL, tile = NULL, gravity = 'Center',
                          bg = 'white', shadow = FALSE){
  assert_image(image)
  geometry <- as.character(geometry)
  tile <- as.character(tile)
  gravity <- as.character(gravity)
  bg <- as.character(bg)
  shadow <- as.logical(shadow)
  magick_image_montage(image, geometry, tile, gravity, bg, shadow)
}
