#' Convert to EBImage
#'
#' Convert a Magck image to [EBImage](https://bioconductor.org/packages/release/bioc/html/EBImage.html)
#' class. Note that EBImage only supports multi-frame images in greyscale.
#'
#' @export
#' @inheritParams editing
as_EBImage <- function(image){
  assert_image(image)
  info <- image_info(image)
  if(length(image) > 1){
    if(!all(tolower(info$colorspace) == 'gray'))
      warning('EBImage does not supported colored multi-frame images. Converting to grayscale.')
    bitmap <- vapply(image, function(x){
      image_data(x, channels = 'gray')[1,,]
    }, matrix(raw(1), info$width, info$height))
    EBImage::Image(as.double(bitmap) / 255, dim(bitmap), EBImage::Grayscale)
  } else {
    bitmap <- aperm(image_data(image), c(2,3,1))
    if(tolower(info$colorspace) == 'gray') {
      EBImage::Image(as.double(bitmap) / 255, dim(bitmap)[1:2], EBImage::Grayscale)
    } else {
      EBImage::Image(as.double(bitmap) / 255, dim(bitmap), EBImage::Color)
    }
  }
}
