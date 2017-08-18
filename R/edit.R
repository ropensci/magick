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
#' @rdname editing
#' @name editing
#' @param path file path, URL, or raw array or \code{nativeRaster} with image data
#' @param image object returned by \code{image_read}
#' @param density resolution to render pdf or svg
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
#' @inheritParams effects
#' @rdname editing
#' @param flatten should image be flattened before writing? This also replaces
#' transparency with background color.
#' @param quality number between 0 and 100 for jpeg quality. Defaults to 75.
#' @param comment text string added to the image metadata for supported formats
image_write <- function(image, path = NULL, format = NULL, quality = NULL,
                        depth = NULL, density = NULL, comment = NULL, flatten = FALSE){
  assert_image(image)
  if(!length(image))
    warning("Writing image with 0 frames")
  if(isTRUE(flatten))
    image <- image_flatten(image)
  format <- toupper(as.character(format))
  quality <- as.integer(quality)
  depth <- as.integer(depth)
  density <- as.character(density)
  comment <- as.character(comment)
  buf <- magick_image_write(image, format, quality, depth, density, comment)
  if(is.character(path)){
    writeBin(buf, path)
    return(invisible(path))
  }
  return(buf)
}

#' @export
#' @rdname editing
#' @param format output format such as \code{png}, \code{jpeg}, \code{gif} or \code{pdf}.
#' Can also be a bitmap type such as \code{rgba} or \code{rgb}.
#' @param depth color depth, must be 8 or 16
#' @param antialias (TRUE/FALSE) enable anti-aliasing for text and strokes
#' @param type a magick \href{https://www.imagemagick.org/Magick++/Enumerations.html#ImageType}{ImageType}
#' classification for example 'grayscale' to convert to black/white
#' @param colorspace string with a magick \href{https://www.imagemagick.org/Magick++/Enumerations.html#ColorspaceType}{ColorspaceType}
#' for example 'grey' or 'rgb' or 'cmyk'
image_convert <- function(image, format = NULL, type = NULL, colorspace = NULL, depth = NULL, antialias = NULL){
  assert_image(image)
  depth <- as.integer(depth)
  antialias <- as.logical(antialias)
  type <- as.character(type)
  colorspace <- as.character(colorspace)
  if(length(depth) && is.na(match(depth, c(8, 16))))
    stop('depth must be 8 or 16 bit')
  magick_image_format(image, toupper(format), type, colorspace, depth, antialias)
}

#' @export
#' @rdname editing
#' @param ... images or lists of images to be combined into a image
image_join <- function(...){
  x <- unlist(list(...))
  stopifnot(all(vapply(x, inherits, logical(1), "magick-image")))
  magick_image_join(x)
}

image_write_frame <- function(image, format = "rgb"){
  assert_image(image)
  magick_image_write_frame(image, format)
}

#' @export
#' @param animate support animations in the X11 display
#' @rdname editing
image_display <- function(image, animate = TRUE){
  magick_image_display(image, animate)
}

#' @export
#' @param browser argument passed to \link[utils:browseURL]{browseURL}
#' @rdname editing
image_browse <- function(image, browser = getOption("browser")){
  ext <- ifelse(length(image), tolower(image_info(image[1])$format), "gif")
  tmp <- tempfile(fileext = paste0(".", ext))
  image_write(image, path = tmp)
  utils::browseURL(tmp)
}

#' @export
#' @rdname editing
image_fft <- function(image){
  if(!isTRUE(magick_config()$fftw))
    stop("ImageMagick was configured without FFTW support. Reinstall with: brew install imagemagick --with-fftw")
  assert_image(image)
  magick_image_fft(image)
}

#' @export
#' @rdname editing
#' @param map reference image to map colors from
#' @param dither set TRUE to enable dithering
image_map <- function(image, map, dither = FALSE){
  assert_image(image)
  stopifnot(inherits(map, "magick-image"))
  magick_image_map(image, map, dither)
}

#' @export
#' @rdname editing
image_info <- function(image){
  assert_image(image)
  magick_image_info(image)
}

