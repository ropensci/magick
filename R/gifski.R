#' Write to GIF
#'
#' Optimized implementation to generate animated gif using [gifski][gifski::gifski].
#'
#' Accomplishes the same thing as [image_animate][image_animate] but with higher quality
#' output. Requires that the gifski package is installed.
#'
#' @inheritParams effects
#' @export
#' @param width output width in pixels. Defaults to first frame of input image.
#' @param height output height in pixels.
#' @param path filename of the output gif. This is also the return value of the function.
#' @param ... extra parameters passed to [gifski][gifski::gifski]
image_write_gif <- function(image, path = NULL, width = NULL, height = NULL, ...){
  imgdir <- tempfile('tmppng')
  dir.create(imgdir)
  on.exit(unlink(imgdir, recursive = TRUE))
  image <- image_convert(image, format = 'png')
  png_files <- vapply(seq_along(image), function(i){
    tmppng <- file.path(imgdir, sprintf("tmpimg_%05d.png", i))
    image_write(image[i], path = tmppng, format = 'png')
  }, character(1))
  info <- image_info(image[1])
  if(!length(width) || !width)
    width <- info$width
  if(!length(height) || !height)
    height <- info$height
  gifski::gifski(png_files, gif_file = path, width = width, height = height, ...)
}
