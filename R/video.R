#' Write Video
#'
#' High quality video / gif exporter based on external packages [gifski][gifski::gifski]
#' and [av][av::av_encode_video].
#'
#' This requires an image with multiple frames. The GIF exporter accomplishes the same
#' thing as [image_animate][image_animate] but much faster and with better quality.
#'
#' @export
#' @rdname video
#' @name video
#' @family image
#' @inheritParams editing
#' @param path filename of the output gif or video. This is also the return value.
#' @param framerate frames per second, passed to [av_encode_video][av::av_encode_video]
#' @param ... additional parameters passed to [av_encode_video][av::av_encode_video] and
#' [gifski][gifski::gifski].
image_write_video <- function(image, path = NULL, framerate = 1, ...){
  png_files <- write_png_files(image)
  on.exit(unlink(png_files))
  av::av_encode_video(png_files, output = path, framerate = framerate, ...)
}

#' @rdname video
#' @export
image_write_gif <- function(image, path = NULL, ...){
  png_files <- write_png_files(image)
  on.exit(unlink(png_files))
  info <- image_info(image)
  width <- info$width[1]
  height <- info$height[1]
  gifski::gifski(png_files, gif_file = path, width = width, height = height, ...)
}

write_png_files <- function(image){
  imgdir <- tempfile('tmppng')
  dir.create(imgdir)
  image <- image_convert(image, format = 'png')
  info <- image_info(image)
  width <- info$width[1]
  height <- info$height[1]
  if(length(unique(info$width)) > 1 || length(unique(info$height)) > 1){
    message(sprintf("Images are not the same size. Resizing to %dx%d...", width, height))
    image <- image_resize(image, sprintf('%dx%d!', width, height))
  }
  vapply(seq_along(image), function(i){
    tmppng <- file.path(imgdir, sprintf("tmpimg_%05d.png", i))
    image_write(image[i], path = tmppng, format = 'png')
  }, character(1))
}
