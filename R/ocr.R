#' Text OCR
#'
#' Extract text from an image using the \link[tesseract:tesseract]{tesseract} package. To use this function
#' you need to tesseract first using: \code{install.packages("tesseract")}.
#'
#' Best results are obtained if you set the correct language in \link[tesseract:tesseract]{tesseract}.
#' To install additional languages see instructions in \link[tesseract:tesseract_download]{tesseract_download}.
#'
#' @export
#' @name ocr
#' @rdname ocr
#' @inheritParams editing
#' @param language passed to \link[tesseract:tesseract]{tesseract}. To install additional languages see
#' instructions in \link[tesseract:tesseract_download]{tesseract_download}.
#' @param ... additional parameters passed to \link[tesseract:tesseract]{tesseract}
#' @examples
#' if(require("tesseract")){
#' img <- image_read("http://jeroen.github.io/images/testocr.png")
#' image_ocr(img)
#' }
image_ocr <- function(image, language = "eng", ...){
  assert_image(image)
  vapply(image, function(x){
    tmp <- tempfile(fileext = ".png")
    on.exit(unlink(tmp))
    buf <- image_write(x, tmp, format = 'PNG', density = "72x72")
    tesseract::ocr(tmp, engine = tesseract::tesseract(language, ...))
  }, character(1))
}
