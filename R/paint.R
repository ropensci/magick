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
#' @param point string indicating the flood-fill starting point
#' @param fuzz Colors within this distance are considered equal.
#' Use this option to match colors that are close to the target color in RGB space.
#' I think max distance (from #000000 to #FFFFFF) is 256^2.
#' @examples
#' logo <- image_read("logo:")
#' logo <- image_transparent(logo, 'white')
#' image_fill(image_flatten(logo), "red")
#' image_fill(image_flatten(logo), "red", fuzz = 25600)
image_fill <- function(image, color, point = "1x1", fuzz = 0){
  assert_image(image)
  magick_image_fill(image, color, point, fuzz)
}

#' @export
#' @rdname painting
#' @param text annotation text
#' @param degrees rotates text around center point
#' @param gravity string with
#' [gravity type](https://www.imagemagick.org/Magick++/Enumerations.html#GravityType)
#' @param location geometry string with location relative to `gravity`
#' @param size font-size in pixels
#' @param strokecolor adds a stroke (border around the text)
#' @param boxcolor background color that annotation text is rendered on.
#' @param font rendering font. To use a TrueType font, precede the TrueType filename with an @.
#' @examples # Add some text to an image
#' image_annotate(logo, "This is a test")
#' image_annotate(logo, "CONFIDENTIAL", size = 50, color = "red", boxcolor = "pink",
#'  degrees = 30, location = "+100+100")
#'
#' # Setting fonts requires fontconfig support (and that you have the font)
#' myfont <- ifelse(identical("windows", .Platform$OS.type), "courier-new", "courier")
#' try(image_annotate(logo, "The quick brown fox", font = myfont, size = 50))
image_annotate <- function(image, text, gravity = "northwest", location = "+0+0", degrees = 0,
                           size = 10, font = NULL, color = NULL, strokecolor = NULL, boxcolor = NULL){
  assert_image(image)
  font <- as.character(font)
  size <- as.integer(size)
  color <- as.character(color)
  strokecolor <- as.character(strokecolor)
  boxcolor <- as.character(boxcolor)
  magick_image_annotate(image, text, gravity, location, degrees, size, font, color, strokecolor, boxcolor)
}
