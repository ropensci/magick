#' Convert to EBImage
#'
#' Convert a Magck image to [EBImage](https://bioconductor.org/packages/release/bioc/html/EBImage.html)
#' class. Note that EBImage only supports multi-frame images in greyscale.
#'
#' @export
#' @inheritParams editing
as_EBImage <- function(image){
  Grayscale <- utils::getFromNamespace('Grayscale', 'EBImage')
  Color <- utils::getFromNamespace('Color', 'EBImage')
  Image <- utils::getFromNamespace('Image', 'EBImage')
  assert_image(image)
  info <- image_info(image)
  if(length(image) > 1){
    if(!all(tolower(info$colorspace) == 'gray'))
      warning('EBImage does not supported colored multi-frame images. Converting to grayscale.')
    bitmap <- vapply(image, function(x){
      image_data(x, channels = 'gray')[1,,]
    }, matrix(raw(1), info$width, info$height))
    Image(as.double(bitmap) / 255, dim(bitmap), Grayscale)
  } else {
    bitmap <- aperm(image_data(image), c(2,3,1))
    if(tolower(info$colorspace) == 'gray') {
      Image(as.double(bitmap) / 255, dim(bitmap)[1:2], Grayscale)
    } else {
      Image(as.double(bitmap) / 255, dim(bitmap), Color)
    }
  }
}
