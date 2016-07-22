#' Image Editing
#'
#' Read, write and join or combine images. All image functions are vectorized,
#' meaning they operate either on a single frame or a series of frames (e.g. a
#' collage, video, or animation).
#' The \href{https://www.imagemagick.org/Magick++/STL.html}{Magick++ documentation}
#' explains meaning of each function and parameter.
#'
#' Besides these functions also R-base functions such as \code{c()}, \code{[},
#' \code{as.list()}, \code{rev}, \code{length}, and \code{print} can be used
#' to work with image frames.
#' See \link{transformations} for vectorized
#' image manipulation functions such as cutting and applying effects.
#'
#' Some configurations of ImageMagick++ support reading SVG files but the rendering
#' is not always very pleasing. Better results can be obtained by first rendering
#' svg to a png using the \href{https://cran.r-project.org/package=rsvg}{rsvg package}.
#'
#' @importFrom Rcpp sourceCpp
#' @useDynLib magick
#' @export
#' @aliases magick imagemagick
#' @family image
#' @rdname edit
#' @name editing
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
#' @inheritParams transformations
#' @rdname edit
image_write <- function(image, path = NULL, format = NULL){
  assert_image(image)
  if(!length(image))
    warning("Writing image with 0 frames")
  if(length(format)){
    image <- magick_image_format(image, format)
  }
  buf <- magick_image_write(image)
  if(is.character(path)){
    writeBin(buf, path)
    return(path)
  }
  return(buf)
}

#' @export
#' @param animate support animations in the X11 display
#' @rdname edit
image_display <- function(image, animate = TRUE){
  magick_image_display(image, animate)
}

#' @export
#' @param browser argument passed to \link[utils:browseURL]{browseURL}
#' @rdname edit
image_browse <- function(image, browser = getOption("browser")){
  tmp <- tempfile()
  image_write(image, path = tmp)
  utils::browseURL(tmp)
}

#' @export
#' @rdname edit
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
  assert_image(image)
  magick_image_append(image, stack)
}

#' @export
#' @rdname edit
image_average <- function(image){
  assert_image(image)
  magick_image_average(image)
}

#' @export
#' @rdname edit
image_coalesce <- function(image){
  assert_image(image)
  magick_image_coalesce(image)
}

#' @export
#' @rdname edit
image_flatten <- function(image){
  assert_image(image)
  magick_image_flatten(image)
}

#' @export
#' @rdname edit
image_fft <- function(image){
  assert_image(image)
  magick_image_fft(image)
}

#' @export
#' @rdname edit
#' @param map reference image to map colors from
#' @param dither set TRUE to enable dithering
image_map <- function(image, map, dither = FALSE){
  assert_image(image)
  stopifnot(inherits(map, "magick-image"))
  magick_image_map(image, map, dither)
}

#' @export
#' @rdname edit
image_montage <- function(image){
  assert_image(image)
  magick_image_montage(image)
}

#' @export
#' @rdname edit
#' @examples
#' # Combine with another image
#' logo <- image_read(system.file("Rlogo.png", package = "magick"))
#' oldlogo <- image_read(system.file("Rlogo-old.png", package = "magick"))
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
#' @rdname edit
image_mosaic <- function(image){
  assert_image(image)
  magick_image_mosaic(image)
}

#' @export
#' @rdname edit
#' @param ... images or lists of images to be combined into a image
#' @examples
#' # Basic compositions
#' image_composite(banana, image_scale(logo, "300"))
#'
#' # Break down and combine frames
#' front <- image_scale(banana, "300")
#' background <- image_scale(logo, "400")
#' frames <- lapply(as.list(front), function(x) image_flatten(c(background, x)))
#' image_animate(image_join(frames))
image_join <- function(...){
  x <- unlist(list(...))
  stopifnot(all(vapply(x, inherits, logical(1), "magick-image")))
  magick_image_join(x)
}

#' @export
#' @rdname edit
image_info <- function(image){
  assert_image(image)
  magick_image_info(image)
}


#' @export
#' @rdname edit
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
