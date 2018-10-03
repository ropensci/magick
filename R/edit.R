#' Image Editing
#'
#' Read, write and join or combine images. All image functions are vectorized, meaning
#' they operate either on a single frame or a series of frames (e.g. a collage, video,
#' or animation). Besides paths and URLs, [image_read()] supports commonly used bitmap
#' and raster object types.
#'
#' All standard base vector methods such as \link{[}, \link{[[}, [c()], [as.list()],
#' [as.raster()], [rev()], [length()], and [print()] can be used to work with magick
#' image objects. Use the standard \code{img[i]} syntax to extract a subset of the frames
#' from an image. The \code{img[[i]]} method is an alias for [image_data()] which extracts
#' a single frame as a raw bitmap matrix with pixel values.
#'
#' For reading svg or pdf it is recommended to use `image_read_svg()` and `image_read_pdf()`
#' if the [rsvg][rsvg::rsvg] and [pdftools][pdftools::pdf_render_page] R packages are available.
#' These functions provide more rendering options and better quality than built-in svg/pdf
#' rendering delegates from imagemagick itself.
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
#' @param strip drop image comments and metadata
#' @examples
#' # Download image from the web
#' frink <- image_read("https://jeroen.github.io/images/frink.png")
#' worldcup_frink <- image_fill(frink, "orange", "+100+200", 20)
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
#' # Read bitmap arrays from from other image packages
#' curl::curl_download("https://jeroen.github.io/images/example.webp", "example.webp")
#' if(require(webp)) image_read(webp::read_webp("example.webp"))
image_read <- function(path, density = NULL, depth = NULL, strip = FALSE){
  if(is.numeric(density))
    density <- paste0(density, "x", density)
  density <- as.character(density)
  depth <- as.integer(depth)
  image <- if(isS4(path) && methods::is(path, "Image")){
    convert_EBImage(path)
  } else if(inherits(path, "nativeRaster") || (is.matrix(path) && is.integer(path))){
    image_read_nativeraster(path)
  } else if (grDevices::is.raster(path)) {
    image_read_raster2(path)
  } else if (is.matrix(path) && is.character(path)){
    image_read_raster2(grDevices::as.raster(path))
  } else if(is.array(path)){
    image_readbitmap(path)
  } else if(is.raw(path)) {
    magick_image_readbin(path, density, depth, strip)
  } else if(is.character(path) && all(nchar(path))){
    path <- vapply(path, replace_url, character(1))
    magick_image_readpath(path, density, depth, strip)
  } else {
    stop("path must be URL, filename or raw vector")
  }
  if(is.character(path) && !isTRUE(magick_config()$rsvg)){
    if(any(grepl("\\.svg$", tolower(path))) || any(grepl("svg|mvg", tolower(image_info(image)$format)))){
      warning("ImageMagick was built without librsvg which causes poor qualty of SVG rendering.
For better results use image_read_svg() which uses the rsvg package.", call. = FALSE)
    }
  }
  return(image)
}

#' @export
#' @rdname editing
#' @examples if(require(rsvg))
#' tiger <- image_read_svg("http://jeroen.github.io/images/tiger.svg")
image_read_svg <- function(path, width = NULL, height = NULL){
  path <- vapply(path, replace_url, character(1))
  images <- lapply(path, function(x){
    bitmap <- rsvg::rsvg_raw(x, width = width, height = height)
    magick_image_readbitmap_raw(bitmap)
  })
  image_join(images)
}

#' @export
#' @rdname editing
#' @param pages integer vector with page numbers. Defaults to all pages.
#' @param password user [password][pdftools::pdf_render_page] to open protected pdf files
#' @examples if(require(pdftools))
#' image_read_pdf(file.path(R.home('doc'), 'NEWS.pdf'), pages = 1, density = 100)
image_read_pdf <- function(path, pages = NULL, density = 300, password = ""){
  path <- replace_url(path)
  if(!length(pages))
    pages <- seq_len(pdftools::pdf_info(path, opw = password)$pages)
  images <- lapply(pages, function(page){
    bitmap <- pdftools::pdf_render_page(path, page = page, dpi = density, opw = password)
    magick_image_readbitmap_raw(bitmap)
  })
  image_join(images)
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

#EBImage BioConductor class
convert_EBImage <- function(x){
  if(length(dim(x@.Data)) == 2)
    dim(x@.Data) <- c(dim(x@.Data), 1L)
  img <- if(x@colormode == 2L){
    image_read(x@.Data)
  } else if(x@colormode == 0L){
    image_join(lapply(seq_len(dim(x@.Data)[3]), function(i){
      image_read(x@.Data[,,i,drop = FALSE])
    }))
  } else {
    stop("Unknown colormode in EBImage class")
  }
  image_flop(image_rotate(img, 90))
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
#' @param type string with [imagetype](https://www.imagemagick.org/Magick++/Enumerations.html#ImageType)
#' value from [image_types][image_types] for example `grayscale` to convert into black/white
#' @param colorspace string with a [`colorspace`](https://www.imagemagick.org/Magick++/Enumerations.html#ColorspaceType)
#' from [colorspace_types][colorspace_types] for example `"gray"`, `"rgb"` or `"cmyk"`
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

image_write_frame <- function(image, format = "rgba", i = 1){
  magick_image_write_frame(image, format = format, i = i)
}

#' @export
#' @rdname editing
#' @param channels string with image channel(s) for example `"rgb"`, `"rgba"`,
#' `"cmyk"`,`"gray"`, or `"ycbcr"`. Default is either `"gray"`, `"rgb"` or `"rgba"`
#' depending on the image
#' @param frame integer setting which frame to extract from the image
image_data <- function(image, channels = NULL, frame = 1){
  if(length(image) > 1 || frame > 1)
    image <- image[frame]
  if(!length(channels) || !nchar(channels)){
    info <- image_info(image)
    channels <- if(tolower(info$colorspace) == "gray"){
      "gray"
    } else if(isTRUE(info$matte)){
      "rgba"
    } else {
      "rgb"
    }
  }
  if(!grepl("a$", channels)) #output has no transparency channel
    image <- image_flatten(image)
  image_write_frame(image, format = channels)
}

#' @export
#' @rdname editing
#' @param tidy converts raster data to long form for use with [geom_raster][ggplot2::geom_raster].
#' If `FALSE` output is the same as `as.raster()`.
image_raster <- function(image, frame = 1, tidy = TRUE){
  raster <- as.raster(image[frame])
  if(!isTRUE(tidy))
    return(raster)
  data.frame(x = rep(seq_len(ncol(raster)), nrow(raster)),
             y = rep(seq_len(nrow(raster)), each = ncol(raster)),
             col = as.vector(raster),
             stringsAsFactors = FALSE)
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
image_strip <- function(image){
  assert_image(image)
  magick_image_strip(image)
}


#' @export
#' @rdname editing
#' @inheritParams device
#' @inheritParams painting
#' @param pseudo_image string with [pseudo image](http://www.imagemagick.org/script/formats.php#pseudo)
#' specification for example `"radial-gradient:purple-yellow"`
#' @examples # create a solid canvas
#' image_blank(600, 400, "green")
#' image_blank(600, 400, pseudo_image = "radial-gradient:purple-yellow")
image_blank <- function(width, height, color = "none", pseudo_image = ""){
  width <- as.numeric(width)
  height <- as.numeric(height)
  color <- as.character(color)
  magick_image_blank(width, height, color, pseudo_image)
}

#' @export
#' @rdname editing
#' @param ... several images or lists of images to be combined
image_join <- function(...){
  x <- unlist(list(...))
  stopifnot(all(vapply(x, inherits, logical(1), "magick-image")))
  magick_image_join(x)
}

#' @export
#' @rdname editing
image_attributes <- function(image){
  assert_image(image)
  magick_image_properties(image)
}

#' @export
#' @rdname editing
demo_image <- function(path){
  image_read(system.file('images', path, package = 'magick'))
}
