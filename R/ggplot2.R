#' Image to ggplot
#'
#' Create a ggplot with axes set to pixel coordinates and plot the raster image
#' on it using [ggplot2::annotation_raster]. See examples for how to plot an image
#' onto an existing ggplot.
#'
#' @export
#' @inheritParams editing
#' @param interpolate passed to [ggplot2::annotation_raster]
#' @examples # Plot with base R
#' plot(logo)
#'
#' # Plot image with ggplot2
#' library(ggplot2)
#' myplot <- image_ggplot(logo)
#' myplot + ggtitle("Test plot")
#'
#' # Show that coordinates are reversed:
#' myplot + theme_classic()
#'
#' # Or add to plot as annotation
#' image <- image_fill(logo, 'none')
#' raster <- as.raster(image)
#' myplot <- qplot(mpg, wt, data = mtcars)
#' myplot + annotation_raster(raster, 25, 35, 3, 5)
#'
#' # Or overplot image using grid
#' library(grid)
#' qplot(speed, dist, data = cars, geom = c("point", "smooth"))
#' grid.raster(image)
image_ggplot <- function(image, interpolate = FALSE) {
  info <- image_info(image)
  ggplot2::ggplot(data.frame(x = 0, y = 0), ggplot2::aes_string('x', 'y')) +
    ggplot2::geom_blank() +
    ggplot2::theme_void() +
    ggplot2::coord_fixed(expand = FALSE, xlim = c(0, info$width), ylim = c(0, info$height)) +
    ggplot2::annotation_raster(image, 0, info$width, info$height, 0, interpolate = interpolate) +
    NULL
}
