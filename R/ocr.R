#' Image Text OCR
#'
#' Extract text from an image using the [tesseract][tesseract::tesseract] package.
#'
#' To use this function you need to tesseract first:
#'
#' ```
#'   install.packages("tesseract")
#' ```
#'
#' Best results are obtained if you set the correct language in [tesseract][tesseract::tesseract].
#' To install additional languages see instructions in [tesseract_download()][tesseract::tesseract_download].
#'
#' @export
#' @family image
#' @name ocr
#' @rdname ocr
#' @inheritParams editing
#' @param language passed to [tesseract][tesseract::tesseract]. To install additional languages see
#' instructions in [tesseract_download()][tesseract::tesseract_download].
#' @param ... additional parameters passed to [tesseract][tesseract::tesseract]
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
