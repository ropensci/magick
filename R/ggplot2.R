#' Image to ggplot
#'
#' Converts image to raster using [image_raster()] and then plots it with ggplot2
#' [geom_raster][ggplot2::geom_raster]. See examples for other ways to use magick
#' images in ggplot2.
#'
#' @export
#' @inheritParams editing
#' @examples # Plot with base R
#' plot(logo)
#'
#' # Plot image with ggplot2
#' library(ggplot2)
#' myplot <- image_ggplot(logo)
#' myplot + ggtitle("Test plot")
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
image_ggplot <- function(image){
  rasterdata <- image_raster(image)
  ggplot2::ggplot(rasterdata) + ggplot2::geom_raster(ggplot2::aes_(~x, ~y, fill = ~col)) +
    ggplot2::coord_fixed(expand = FALSE) + ggplot2::scale_y_reverse() +
    ggplot2::scale_fill_identity() + ggplot2::theme_void()
}
