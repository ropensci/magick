#' @export
"[.magick-image" <- function(x, i){
  stopifnot(inherits(x, "magick-image"))
  stopifnot(is.numeric(i))
  i <- seq_along(x)[i]  # normalize to positive subscripts
  magick_image_subset(x, i)
}

#' @export
"[[.magick-image" <- function(x, i){
  stopifnot(inherits(x, "magick-image"))
  stop("[[ not yet implemented")
  #magick_image_frame(x, i)
}

#' @export
"c.magick-image" <- function(...){
  x <- unlist(list(...))
  stopifnot(all(vapply(x, inherits, logical(1), "magick-image")))
  magick_image_join(x)
}

#' @export
"length.magick-image" <- function(x){
  stopifnot(inherits(x, "magick-image"))
  magick_image_length(x)
}

#' @export
"rev.magick-image" <- function(x){
  stopifnot(inherits(x, "magick-image"))
  magick_image_rev(x)
}

#' @export
"as.list.magick-image" <- function(x, ...){
  stopifnot(inherits(x, "magick-image"))
  len <- length(x)
  lapply(seq_len(len), magick_image_subset, image = x)
}

#' @export
"print.magick-image" <- function(x, ...){
  viewer <- getOption("viewer")
  if(is.function(viewer)){
    tmp <- file.path(tempdir(), "preview.gif")
    image_write(x, path = tmp)
    viewer(tmp)
  }
  NextMethod()
}
