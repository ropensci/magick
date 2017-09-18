#' Image Editing
#'
#' Read, write and join or combine images.
#' All image functions are vectorized, meaning they operate either on a single frame
#' or a series of frames (e.g. a collage, video, or animation).
#' Besides paths and URLs, the [image_read()] function supports all commonly used bitmap
#' and raster types.
#'
#' Besides functions
#' above, all standard base vector methods such as \link{[}, \link{[[}, [c()], [as.list()],
#' [as.raster()], [rev()], [length()], and [print()]  can be used with magick images.
#'
#' Use the standard \code{img[i]} syntax to extract a subset of the frames from an image.
#' The \code{img[[i]]} method is used to extract a single frame as a bitmap object, i.e.
#' a raw matrix with pixel values.
#'
#'
#' X11 is required for `image_display()` which is only works on some platforms. A more
#' portable method is `image_browse()` which opens the image in a browser. RStudio has
#' an embedded viewer that does this automatically which is quite nice.
#'
#' @importFrom Rcpp sourceCpp
#' @useDynLib magick
#' @export
#' @family image
#' @rdname editing
#' @name editing
#' @param path a file, url, or raster object or bitmap array
#' @param image magick image object returned by [image_read()] or [image_graph()]
#' @param density resolution to render pdf or svg
#' @examples
#' # Download image from the web
#' frink <- image_read("https://jeroen.github.io/images/frink.png")
#' worldcup_frink <- image_fill(frink, "orange", "+100+200", 30000)
#' image_write(worldcup_frink, "output.png")
#'
#' # extract raw bitmap array
#' bitmap <- frink[[1]]
#'
#' # replace pixels with #FF69B4 ('hot pink') and convert back to image
#' bitmap[,50:100, 50:100] <- as.raw(c(0xff, 0x69, 0xb4, 0xff))
#' image_read(bitmap)
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
#' @param format output format such as `"png"`, `"jpeg"`, `"gif"`, `"rgb"` or `"rgba"`.
#' @param depth color depth (either 8 or 16)
#' @param antialias enable anti-aliasing for text and strokes
#' @param type a magick [ImageType](https://www.imagemagick.org/Magick++/Enumerations.html#ImageType)
#' classification for example `grayscale` to convert image to black/white
#' @param colorspace string with a magick [ColorspaceType](https://www.imagemagick.org/Magick++/Enumerations.html#ColorspaceType)
#' for example `"gray"`, `"rgb"` or `"cmyk"`
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

image_write_frame <- function(image, format = "rgba"){
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
#' @param browser argument passed to [browseURL][utils::browseURL]
#' @rdname editing
image_browse <- function(image, browser = getOption("browser")){
  ext <- ifelse(length(image), tolower(image_info(image[1])$format), "gif")
  tmp <- tempfile(fileext = paste0(".", ext))
  image_write(image, path = tmp)
  utils::browseURL(tmp)
}

#' @export
#' @rdname editing
#' @param ... several images or lists of images to be combined
image_join <- function(...){
  x <- unlist(list(...))
  stopifnot(all(vapply(x, inherits, logical(1), "magick-image")))
  magick_image_join(x)
}
