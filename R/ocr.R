#' OCR
#'
#' Extract text from an image. Requires the 'tesseract' package.
#'
#' @export
#' @inheritParams editing
#' @param ... additional parameters passed to \code{tesseract::tesseract()}
#' @examples
#' img <- image_read("http://jeroen.github.io/images/testocr.png")
#' image_ocr(img)
image_ocr <- function(image, ...){
  assert_image(image)
  vapply(image, function(x){
    tmp <- tempfile(fileext = ".png")
    on.exit(tmp)
    image_write(x, tmp, format = 'png')
    tesseract::ocr(tmp, engine = tesseract::tesseract(...))
  }, character(1))
}
