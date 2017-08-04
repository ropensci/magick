#' OCR
#'
#' Extract text from an image. Requires the 'tesseract' package.
#'
#' @export
#' @inheritParams editing
#' @param ... additional parameters passed to \code{tesseract::tesseract()}
#' @examples
#' if(require("tesseract")){
#' img <- image_read("http://jeroen.github.io/images/testocr.png")
#' image_ocr(img)
#' }
image_ocr <- function(image, ...){
  assert_image(image)
  vapply(image, function(x){
    tmp <- tempfile(fileext = ".png")
    on.exit(unlink(tmp))
    buf <- image_write(x, tmp, format = 'PNG', density = "72x72")
    tesseract::ocr(tmp, engine = tesseract::tesseract(...))
  }, character(1))
}
