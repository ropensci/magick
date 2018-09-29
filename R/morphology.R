#' Morphology
#'
#' Apply a morphology method. This is a very flexible function which
#' can be used to apply any morphology method with custom parameters.
#' See [imagemagick website](http://www.imagemagick.org/Usage/morphology/)
#' for examples.
#'
#' @export
#' @inheritParams effects
#' @param method a string with a valid method from [morphology_types()]
#' @param opts a named list or character vector with custom attributes
#' @rdname morphology
#' @name morphology
#' @family image
#' @examples #example from IM website:
#' if(magick_config()$version > "6.8.8"){
#' pixel <- image_blank(1, 1, 'white') %>% image_border('black', '5x5')
#'
#' # See the effect of Dilate method
#' pixel %>% image_scale('800%')
#' pixel %>% image_morphology('Dilate', "Diamond") %>% image_scale('800%')
#'
#' # These produce the same output:
#' pixel %>% image_morphology('Dilate', "Diamond", iter = 3) %>% image_scale('800%')
#' pixel %>% image_morphology('Dilate', "Diamond:3") %>% image_scale('800%')
#'
#' # Plus example
#' pixel %>% image_morphology('Dilate', "Plus", iterations = 2) %>% image_scale('800%')
#'
#' # Rose examples
#' rose %>% image_morphology('ErodeI', 'Octagon', iter = 3)
#' rose %>% image_morphology('DilateI', 'Octagon', iter = 3)
#' rose %>% image_morphology('OpenI', 'Octagon', iter = 3)
#' rose %>% image_morphology('CloseI', 'Octagon', iter = 3)
#'
#' # Edge detection
#' man <- image_read(system.file('images/man.gif', package = 'magick'))
#' man %>% image_morphology('EdgeIn', 'Octagon')
#' man %>% image_morphology('EdgeOut', 'Octagon')
#' man %>% image_morphology('Edge', 'Octagon')
#'
#' # Octagonal Convex Hull
#'  man %>%
#'    image_morphology('Close', 'Diamond') %>%
#'    image_morphology('Thicken', 'ConvexHull', iterations = -1)
#'
#' # Thinning down to a Skeleton
#' man %>% image_morphology('Thinning', 'Skeleton', iterations = -1)
#' }
image_morphology <- function(image, method = "convolve", kernel = "Gaussian",
                             iterations = 1, opts = list()){
  assert_image(image)
  method <- as.character(method)
  kernel <- as.character(kernel)
  iterations <- as.integer(iterations)
  opt_names <- as.character(names(opts))
  opt_values <- as.character(unname(opts))
  magick_image_morphology(image, method, kernel, iterations, opt_names, opt_values)
}

#' @export
#' @rdname morphology
#' @param kernel either a matrix or a string with parameterized [kerneltype][kernel_types] such as:
#' `"DoG:0,0,2"` or `"Diamond"`
#' @param iterations number of iterations
#' @param scaling string with kernel scaling. The special flag `"!"` automatically scales to full
#' dynamic range, for example: \code{"50\%!"}
#' @param bias output bias string, for example \code{"50\%"}
image_convolve <- function(image, kernel = 'Gaussian', iterations = 1, scaling = NULL, bias = NULL){
  assert_image(image)
  iterations <- as.integer(iterations)
  scaling <- as.character(scaling)
  bias <- as.character(bias)
  if(is.character(kernel)){
    magick_image_convolve_kernel(image, kernel, iterations, scaling, bias)
  } else if(is.matrix(kernel)) {
    magick_image_convolve_matrix(image, kernel, iterations, scaling, bias)
  } else {
    stop("Argument 'kernel' must either be a string or matrix")
  }
}

