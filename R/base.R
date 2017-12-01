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
  image_data(x[i])
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
  if(magick_image_dead(x))
    return(NULL)
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
"print.magick-image" <- function(x, info = TRUE, ...){
  img <- x
  viewer <- getOption("viewer")
  viewer_supported <- c("bmp", "png", "jpeg", "jpg", "svg", "gif", "webp")
  is_knit_image <- isTRUE(getOption('knitr.in.progress'))
  if(!is_knit_image && is.function(viewer) && !magick_image_dead(x) && length(img)){
    format <- tolower(image_info(img[1])$format)
    if(length(img) > 1 && format != "gif"){
      img <- image_animate(img, fps = 1)
      format <- "gif"
    } else if(is.na(match(format, viewer_supported))){
      img <- image_convert(img, "PNG")
      format <- 'png'
    }
    tmp <- file.path(tempdir(), paste0("preview.", format))
    image_write(img, path = tmp, format = format)
    viewer(tmp)
  }
  if(isTRUE(info))
    print(image_info(x))
  if(is_knit_image)
    `knit_print.magick-image`(x)
  else
    invisible()
}

#' @export
#' @method knit_print magick-image
#' @importFrom knitr knit_print
"knit_print.magick-image" <- function(x, ...){
  if(!length(x))
    return(invisible())
  ext <- ifelse(all(tolower(image_info(x)$format) == "gif"), "gif", "png")
  tmp <- tempfile(fileext = paste0(".", ext))
  image_write(x, path = tmp, format = ext)
  knitr::include_graphics(tmp)
}

#' @export
#' @importFrom grDevices as.raster
"as.raster.magick-image" <- function(image, ...){
  assert_image(image)
  bitmap <- image_write_frame(image, format = "rgba")
  magick_image_as_raster(bitmap)
}

#' @export
#' @importFrom graphics plot
"plot.magick-image" <- function(x, ...){
  plot(as.raster(x), ...)
}
