#' Image Painting
#'
#' The [image_fill()] function performs flood-fill by painting starting point and all
#' neighboring pixels of approximately the same color. Annotate simply prints some
#' text on the image.
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
#' `"navyblue"` or `"#000080"`
#' @param point a [geometry_point] string indicating the starting point of the flood-fill
#' @param fuzz Fuzz percentage: value between 0 and 100. Relative distance between
#' colors to be considered similar in the filling algorithm.
#' @examples
#' logo <- image_read("logo:")
#' logo <- image_background(logo, 'white')
#' image_fill(logo, "pink", point = "+450+400")
#' image_fill(logo, "pink", point = "+450+400", fuzz = 25)
image_fill <- function(image, color, point = "1x1", fuzz = 0){
  assert_image(image)
  color <- as.character(color)
  point <- as.character(point)
  if(fuzz > 100)
    stop("Parameter 'fuzz' must be percentage value (0-100)")
  magick_image_fill(image, color, point, fuzz)
}

#' @export
#' @rdname painting
#' @param text annotation text
#' @param degrees rotates text around center point
#' @param gravity string with
#' [gravity](https://www.imagemagick.org/Magick++/Enumerations.html#GravityType)
#' value from [gravity_types].
#' @param location geometry string with location relative to `gravity`
#' @param size font-size in pixels
#' @param strokecolor a [color string](https://www.imagemagick.org/Magick++/Color.html)
#' adds a stroke (border around the text)
#' @param boxcolor a [color string](https://www.imagemagick.org/Magick++/Color.html)
#' for background color that annotation text is rendered on.
#' @param font string with font family such as `"sans"`, `"mono"`, `"serif"`,
#' `"Times"`, `"Helvetica"`, `"Trebuchet"`, `"Georgia"`, `"Palatino"` or `"Comic Sans"`.
#' @examples # Add some text to an image
#' image_annotate(logo, "This is a test")
#' image_annotate(logo, "CONFIDENTIAL", size = 50, color = "red", boxcolor = "pink",
#'  degrees = 30, location = "+100+100")
#'
#' # Setting fonts requires fontconfig support (and that you have the font)
#' image_annotate(logo, "The quick brown fox", font = "monospace", size = 50)
image_annotate <- function(image, text, gravity = "northwest", location = "+0+0", degrees = 0,
                           size = 10, font = "", color = NULL, strokecolor = NULL, boxcolor = NULL){
  assert_image(image)
  font <- as.character(font)
  size <- as.integer(size)
  color <- as.character(color)
  strokecolor <- as.character(strokecolor)
  boxcolor <- as.character(boxcolor)
  magick_image_annotate(image, text, gravity, location, degrees, size, font, color, strokecolor, boxcolor)
}
