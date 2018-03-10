#' Image to ggplot
#'
#' Converts image to raster using [image_raster()] and then plots it with ggplot2
#' [geom_raster][ggplot2::geom_raster].
#'
#' @export
#' @inheritParams editing
#' @examples # Plot with base R
#' plot(logo)
#'
#' # Plot with ggplot2
#' library(ggplot2)
#' myplot <- image_ggplot(logo)
#' myplot + ggtitle("Test plot")
#'
#' # Or plot as fixed annotation
#' raster <- as.raster(image_fill(logo, 'none'))
#' myplot <- qplot(mpg, wt, data = mtcars)
#' myplot + annotation_raster(raster, 25, 35, 3, 5)
image_ggplot <- function(image){
  rasterdata <- image_raster(image)
  ggplot2::ggplot(rasterdata) + ggplot2::geom_raster(ggplot2::aes(x, y, fill = col)) +
    ggplot2::coord_fixed(expand = FALSE) + ggplot2::scale_y_reverse() +
    ggplot2::scale_fill_identity() + ggplot2::theme_void()
}
