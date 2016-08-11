#' @export
"[.magick-image" <- function(x, i){
  assert_image(x)
  stopifnot(is.numeric(i))
  i <- seq_along(x)[i]  # normalize to positive subscripts
  magick_image_subset(x, i)
}

#TODO: return 3 ch 'rgb' or 1 ch greyscale bitmap depending on colorspace
#' @export
"[[.magick-image" <- function(x, i){
  assert_image(x)
  image <- x[i]
  info <- image_info(image)
  bitmap <- image_write(image, format = "rgba")
  dim(bitmap) <- c(4, info$width, info$height)
  class(bitmap) <- c("bitmap", "rgba")
  return(bitmap)
}

#' @export
"print.bitmap" <- function(x, ...){
  dims <- dim(x)
  cat(sprintf("%d channel %dx%d bitmap array:", dims[1], dims[2], dims[3]))
  utils::str(x)
}

#' @export
"c.magick-image" <- function(...){
  image_join(...)
}

#' @export
"length.magick-image" <- function(x){
  assert_image(x)
  magick_image_length(x)
}

#' @export
"rev.magick-image" <- function(x){
  assert_image(x)
  magick_image_rev(x)
}

#' @export
"as.list.magick-image" <- function(x, ...){
  assert_image(x)
  len <- length(x)
  lapply(seq_len(len), magick_image_subset, image = x)
}

#' @export
"print.magick-image" <- function(x, ...){
  viewer <- getOption("viewer")
  ext <- ifelse(length(x), tolower(image_info(x[1])$format), "gif")
  if(is.function(viewer)){
    tmp <- file.path(tempdir(), paste0("preview.", ext))
    image_write(x, path = tmp)
    viewer(tmp)
  }
  print(image_info(x))
  invisible()
}

## apply is slow, can easily be optimized in c++.
#' @export
#' @importFrom grDevices as.raster
"as.raster.magick-image" <- function(x, flatten = TRUE, ...){
  image <- x[1]
  # flatten can change length/dimensions!
  if(isTRUE(flatten)){
    image <- image_flatten(image)
  }
  info <- image_info(image)
  bitmap <- as.character(image_write(image, format = "rgb"))
  dim(bitmap) <- c(3, info$width, info$height)
  raster <- apply(bitmap, 3:2, function(x){paste0(c('#', x), collapse = "")})
  as.raster(raster)
}
