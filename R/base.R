#' @export
"[.magick-image" <- function(x, i){
  assert_image(x)
  stopifnot(is.numeric(i))
  i <- seq_along(x)[i]  # normalize to positive subscripts
  magick_image_subset(x, i)
}

#' @export
"[[.magick-image" <- function(x, i){
  assert_image(x)
  stop("[[ not yet implemented")
  #magick_image_frame(x, i)
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
