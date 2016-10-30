#' @export
"[.magick-image" <- function(x, i){
  assert_image(x)
  stopifnot(is.numeric(i))
  i <- seq_along(x)[i]  # normalize to positive subscripts
  magick_image_subset(x, i)
}

#' @export
"[<-.magick-image" <- function(x, i, value){
  assert_image(x)
  assert_image(value)
  stopifnot(is.numeric(i))
  i <- seq_along(x)[i]
  magick_image_replace(x, i, value)
}

#TODO: return 3 ch 'rgb' or 1 ch greyscale bitmap depending on colorspace
#' @export
"[[.magick-image" <- function(x, i){
  assert_image(x)
  image <- x[i]
  info <- image_info(image)
  bitmap <- image_write_frame(image, format = "rgba")
  dim(bitmap) <- c(4, info$width, info$height)
  class(bitmap) <- c("bitmap", "rgba")
  return(bitmap)
}

#' @export
"[[<-.magick-image" <- function(x, i, value){
  stop("[[ assignment not implemented. Try single bracket.")
}

#' @export
"print.bitmap" <- function(x, ...){
  dims <- dim(x)
  cat(sprintf("%d channel %dx%d bitmap array:", dims[1], dims[2], dims[3]))
  utils::str(x)
}

#' @export
"as.integer.bitmap" <- function(x, transpose = TRUE, ...){
  if(transpose){
    x <- aperm(x)
  }
  structure(as.vector(x, mode = 'integer'), dim = dim(x))
}

#' @export
"as.double.bitmap" <- function(x, transpose = TRUE, ...){
  if(transpose){
    x <- aperm(x)
  }
  structure(as.vector(x, mode = 'double') / 255, dim = dim(x))
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

#' @export
#' @importFrom grDevices as.raster
"as.raster.magick-image" <- function(image, ...){
  assert_image(image)
  magick_image_as_raster(image[[1]])
}


#' @export
#' @importFrom graphics plot
"plot.magick-image" <- function(x, ...){
  plot(as.raster(x), ...)
}
