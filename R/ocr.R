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
#' image_ocr_data(img)
#' }
image_ocr <- function(image, language = "eng", ...){
  assert_image(image)
  tesseract::ocr(image, engine = tesseract::tesseract(language, ...))
}


#' @export
#' @rdname ocr
image_ocr_data <- function(image, language = "eng", ...){
  assert_image(image)
  tesseract::ocr_data(image, engine = tesseract::tesseract(language, ...))
}
