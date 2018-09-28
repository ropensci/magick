#' Write to GIF
#'
#' Optimized implementation to generate animated gif using [gifski][gifski::gifski].
#'
#' Accomplishes the same thing as [image_animate][image_animate] but with higher quality
#' output. Requires that the gifski package is installed.
#'
#' @inheritParams effects
#' @export
#' @param path filename of the output gif. This is also the return value of the function.
#' @param ... extra parameters passed to [gifski][gifski::gifski]
image_write_gif <- function(image, path = NULL, ...){
  imgdir <- tempfile('tmppng')
  dir.create(imgdir)
  on.exit(unlink(imgdir, recursive = TRUE))
  image <- image_convert(image, format = 'png')
  info <- image_info(image)
  width <- info$width[1]
  height <- info$height[1]
  if(length(unique(info$width)) > 1 || length(unique(info$height)) > 1)
    image <- image_resize(image, sprintf('%dx%d!', width, height))
  png_files <- vapply(seq_along(image), function(i){
    tmppng <- file.path(imgdir, sprintf("tmpimg_%05d.png", i))
    image_write(image[i], path = tmppng, format = 'png')
  }, character(1))
  gifski::gifski(png_files, gif_file = path, width = width, height = height, ...)
}
