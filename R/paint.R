#' Image Painting
#'
#' The [image_fill()] function performs flood-fill by painting starting point and all
#' neighboring pixels of approximately the same color. Annotate prints some text on
#' the image.
#'
#' Note that more sophisticated drawing mechanisms are available via the graphics
#' device using [image_draw].
#'
#' @export
#' @name painting
#' @rdname painting
#' @family image
#' @inheritParams editing
#' @param color a valid [color string](https://www.imagemagick.org/Magick++/Color.html) such as
#' `"navyblue"` or `"#000080"`. Use `"none"` for transparency.
#' @param point a geometry_point string indicating the starting point of the flood-fill
#' @param fuzz relative color distance (value between 0 and 100) to be considered similar
#' in the filling algorithm
#' @param refcolor if set, `fuzz` color distance will be measured against this color,
#' not the color of the starting `point`. Any color (within `fuzz` color distance of
#' the given `refcolor`), connected to starting point will be replaced with the `color`.
#' If the pixel at the starting point does not itself match the given `refcolor`
#' (according to `fuzz`) then no action will be taken.
#' @examples
#' logo <- image_read("logo:")
#' logo <- image_background(logo, 'white')
#' image_fill(logo, "pink", point = "+450+400")
#' image_fill(logo, "pink", point = "+450+400", fuzz = 25)
image_fill <- function(image, color, point = "+1+1", fuzz = 0, refcolor = NULL){
  assert_image(image)
  color <- as.character(color)
  point <- as.character(point)
  refcolor <- as.character(refcolor)
  if(fuzz > 100)
    stop("Parameter 'fuzz' must be percentage value (0-100)")
  magick_image_fill(image, color, point, fuzz, refcolor)
}

#' @export
#' @details Setting a font, weight, style only works if your imagemagick is compiled
#' with fontconfig support.
#' @rdname painting
#' @param text character vector of length equal to 'image' or length 1
#' @param degrees rotates text around center point
#' @param gravity string with
#' [gravity](https://www.imagemagick.org/Magick++/Enumerations.html#GravityType)
#' value from [gravity_types].
#' @param location geometry string with location relative to `gravity`
#' @param size font-size in pixels
#' @param strokecolor a [color string](https://www.imagemagick.org/Magick++/Color.html)
#' adds a stroke (border around the text)
#' @param strokewidth set the strokewidth of the border around the text
#' @param boxcolor a [color string](https://www.imagemagick.org/Magick++/Color.html)
#' for background color that annotation text is rendered on.
#' @param font string with font family such as `"sans"`, `"mono"`, `"serif"`,
#' `"Times"`, `"Helvetica"`, `"Trebuchet"`, `"Georgia"`, `"Palatino"` or `"Comic Sans"`.
#' See [magick_fonts()] for what is available.
#' @param style value of [style_types][style_types] for example `"italic"`
#' @param weight thickness of the font, 400 is normal and 700 is bold, see [magick_fonts()].
#' @param kerning increases or decreases whitespace between letters
#' @param decoration value of [decoration_types][decoration_types] for example `"underline"`
#' @examples # Add some text to an image
#' image_annotate(logo, "This is a test")
#' image_annotate(logo, "CONFIDENTIAL", size = 50, color = "red", boxcolor = "pink",
#'  degrees = 30, location = "+100+100")
#'
#' # Setting fonts requires fontconfig support (and that you have the font)
#' image_annotate(logo, "The quick brown fox", font = "monospace", size = 50)
image_annotate <- function(image, text, gravity = "northwest", location = "+0+0", degrees = 0,
                           size = 10, font = "", style = "normal", weight = 400, kerning = 0,
                           decoration = NULL, color = NULL, strokecolor = NULL,
                           strokewidth = NULL, boxcolor = NULL){
  assert_image(image)
  font <- as.character(font)
  size <- as.integer(size)
  weight <- as.numeric(weight)
  kerning <- as.numeric(kerning)
  color <- as.character(color)
  strokecolor <- as.character(strokecolor)
  strokewidth <- as.integer(strokewidth)
  boxcolor <- as.character(boxcolor)
  decoration <- as.character(decoration)
  magick_image_annotate(image, text, gravity, location, degrees, size,
                        font, style, weight, kerning, decoration,
                        color, strokecolor, strokewidth, boxcolor)
}
