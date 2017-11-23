#' Convert to EBImage
#'
#' Convert a Magck image to [EBImage](https://bioconductor.org/packages/release/bioc/html/EBImage.html)
#' class.
#'
#' @export
#' @inheritParams editing
as_EBImage <- function(image){
  assert_image(image)
  info <- image_info(image)
  if(length(image) > 1){
    bitmap <- vapply(image, function(x){
      image_data(x, channels = 'gray')[1,,]
    }, matrix(raw(1), info$width, info$height))
    EBImage::Image(as.double(bitmap) / 255, dim(bitmap), EBImage::Grayscale)
  } else if(tolower(info$colorspace) == 'gray') {
    bitmap <- image_data(image)
    bitmap <- aperm(bitmap, c(2,3,1))
    EBImage::Image(as.double(bitmap) / 255, dim(bitmap)[1:2], EBImage::Grayscale)
  } else {
    bitmap <- image_data(image)
    bitmap <- aperm(bitmap, c(2,3,1))
    EBImage::Image(as.double(bitmap) / 255, dim(bitmap), EBImage::Color)
  }
}
