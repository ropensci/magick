#' Image Editing
#'
#' Read, write and join or combine images. All image functions are vectorized,
#' meaning they operate either on a single frame or a series of frames (e.g. a
#' collage, video, or animation).
#' The \href{https://www.imagemagick.org/Magick++/STL.html}{Magick++ documentation}
#' explains meaning of each function and parameter.
#'
#' Besides these functions also R-base functions such as \code{c()}, \code{[},
#' \code{as.list()}, \code{as.raster()}, \code{rev}, \code{length}, and \code{print}
#' can be used to work with image frames.
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
#' @param path file path, URL, or raw array or \code{nativeRaster} with image data
#' @param image object returned by \code{image_read}
#' @param density resolution to render pdf or svg
#' @param depth image depth. Must be 8 or 16
#' @references Magick++ Image STL: \url{https://www.imagemagick.org/Magick++/STL.html}
#' @examples
#' # Download image from the web
#' frink <- image_read("https://jeroen.github.io/images/frink.png")
#' worldcup_frink <- image_fill(frink, "orange", "+100+200", 30000)
#' image_write(worldcup_frink, "output.png")
#'
#' # Plot to graphics device via legacy raster format
#' raster <- as.raster(frink)
#' par(ask=FALSE)
#' plot(raster)
#'
#' # Read bitmap arrays
#' curl::curl_download("https://www.r-project.org/logo/Rlogo.png", "Rlogo.png")
#' image_read(png::readPNG("Rlogo.png"))
#'
#' curl::curl_download("https://jeroen.github.io/images/example.webp", "example.webp")
#' image_read(webp::read_webp("example.webp"))
#'
#' curl::curl_download("http://jeroen.github.io/images/tiger.svg", "tiger.svg")
#' image_read(rsvg::rsvg("tiger.svg"))
image_read <- function(path, density = NULL, depth = NULL){
  density <- as.character(density)
  depth <- as.integer(depth)
  image <- if(inherits(path, "nativeRaster") || (is.matrix(path) && is.integer(path))){
    image_read_nativeraster(path)
  } else if (grDevices::is.raster(path)) {
    image_read_raster2(path)
  } else if (is.matrix(path) && is.character(path)){
    image_read_raster2(grDevices::as.raster(path))
  } else if(is.array(path)){
    image_readbitmap(path)
  } else if(is.raw(path)) {
    magick_image_readbin(path, density, depth)
  } else if(is.character(path) && all(nchar(path))){
    path <- vapply(path, replace_url, character(1))
    magick_image_readpath(path, density, depth)
  } else {
    stop("path must be URL, filename or raw vector")
  }
  if(is.character(path) && !isTRUE(magick_config()$rsvg)){
    if(any(grepl("\\.svg$", tolower(path))) || any(grepl("svg|mvg", tolower(image_info(image)$format)))){
      warning("ImageMagick was built without librsvg which causes poor qualty of SVG rendering.
For better results, rebuild ImageMagick --with-librsvg or use the 'rsvg' package in R.", call. = FALSE)
    }
  }
  return(image)
}

image_readbitmap <- function(x){
  if(length(dim(x)) != 3)
    stop("Only 3D arrays can be converted to bitmaps")
  if(is.raw(x)){
    magick_image_readbitmap_raw(x)
  } else if(is.double(x)){
    magick_image_readbitmap_double(aperm(x))
  } else {
    stop("Unsupported bitmap array type")
  }
}

# output of dev.caputure(native = TRUE)
image_read_nativeraster <- function(x){
  stopifnot(is.matrix(x) && is.integer(x))
  magick_image_readbitmap_native(x)
}

# output of dev.caputure(native = FALSE) or as.raster()
image_read_raster1 <- function(x){
  stopifnot(is.matrix(x) && is.character(x))
  magick_image_readbitmap_raster1(t(x))
}

# output of as.raster()
image_read_raster2 <- function(x){
  stopifnot(is.matrix(x) && is.character(x))
  magick_image_readbitmap_raster2(x)
}

# Not exported for now
image_rsvg <- function(path, width = NULL, height = NULL){
  bitmap <- rsvg::rsvg_raw(path, width = width, height = height)
  magick_image_readbitmap_raw(bitmap)
}

#' @export
#' @inheritParams transformations
#' @rdname edit
#' @param flatten should image be flattened before writing? This also replaces
#' transparency with background color.
#' @param quality number between 0 and 100 for jpeg quality. Defaults to 75.
image_write <- function(image, path = NULL, format = NULL, quality = NULL,
                        depth = NULL, density = NULL, flatten = FALSE){
  assert_image(image)
  if(!length(image))
    warning("Writing image with 0 frames")
  if(isTRUE(flatten))
    image <- image_flatten(image)
  format <- toupper(as.character(format))
  quality <- as.integer(quality)
  depth <- as.integer(depth)
  density <- as.character(density)
  buf <- magick_image_write(image, format, quality, depth, density)
  if(is.character(path)){
    writeBin(buf, path)
    return(invisible(path))
  }
  return(buf)
}

image_write_frame <- function(image, format = "rgb"){
  assert_image(image)
  magick_image_write_frame(image, format)
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
  ext <- ifelse(length(image), tolower(image_info(image[1])$format), "gif")
  tmp <- tempfile(fileext = paste0(".", ext))
  image_write(image, path = tmp)
  utils::browseURL(tmp)
}

#' @export
#' @rdname edit
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
image_flatten <- function(image, operator = NULL){
  assert_image(image)
  operator <- as.character(operator)
  magick_image_flatten(image, operator)
}

#' @export
#' @rdname edit
image_fft <- function(image){
  if(!isTRUE(magick_config()$fftw))
    stop("ImageMagick was configured without FFTW support. Reinstall with: brew install imagemagick --with-fftw")
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
#' @rdname edit
image_mosaic <- function(image, operator = NULL){
  assert_image(image)
  operator <- as.character(operator)
  magick_image_mosaic(image, operator)
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
#' background <- image_background(image_scale(logo, "400"), 'white')
#' frames <- image_apply(front, function(x){image_composite(background, x, offset = "+70+30")})
#' image_animate(frames, fps = 10)
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
