#' Image Effects
#'
#' High level effects applied to an entire image.
#' These are mostly just for fun.
#'
#' @name effects
#' @inheritParams editing
#' @family image
#' @rdname effects
#' @export
#' @param times number of times to repeat the despeckle operation
#' @examples logo <- image_read("logo:")
#' image_despeckle(logo)
image_despeckle <- function(image, times = 1L){
  assert_image(image)
  magick_image_despeckle(image, times)
}

#' @export
#' @rdname effects
#' @examples image_reducenoise(logo)
image_reducenoise <- function(image, radius = 1L){
  assert_image(image)
  magick_image_reducenoise(image, radius)
}

#' @export
#' @rdname effects
#' @param noisetype string with a
#' [noisetype](https://www.imagemagick.org/Magick++/Enumerations.html#NoiseType) value
#' from [noise_types][noise_types].
#' @examples
#' image_noise(logo)
image_noise <- function(image, noisetype = "gaussian"){
  assert_image(image)
  magick_image_noise(image, noisetype)
}

#' @export
#' @rdname effects
#' @param radius radius, in pixels, for various transformations
#' @param sigma the standard deviation of the Laplacian, in pixels.
#' @examples
#' image_blur(logo, 10, 10)
image_blur <- function(image, radius = 1, sigma = 0.5){
  assert_image(image)
  magick_image_blur(image, radius, sigma)
}

#' @export
#' @rdname effects
#' @examples
#' image_charcoal(logo)
image_charcoal <- function(image, radius = 1, sigma = 0.5){
  assert_image(image)
  magick_image_charcoal(image, radius, sigma)
}

#' @export
#' @rdname effects
#' @examples
#' image_edge(logo)
image_edge <- function(image, radius = 1){
  assert_image(image)
  magick_image_edge(image, radius)
}

#' @export
#' @rdname effects
#' @examples
#' image_oilpaint(logo, radius = 3)
image_oilpaint <- function(image, radius = 1){
  assert_image(image)
  magick_image_oilpaint(image, radius)
}

#' @export
#' @rdname effects
#' @examples
#' image_emboss(logo)
image_emboss <- function(image, radius = 1, sigma = 0.5){
  assert_image(image)
  magick_image_emboss(image, radius, sigma)
}

#' @export
#' @rdname effects
#' @param factor image implode factor (special effect)
#' @examples
#' image_implode(logo)
image_implode <- function(image, factor = 0.5){
  assert_image(image)
  magick_image_implode(image, factor)
}

#' @export
#' @rdname effects
#' @examples
#' image_negate(logo)
image_negate <- function(image){
  assert_image(image)
  magick_image_negate(image)
}

#' @export
#' @rdname effects
#' @param kernel either a matrix or a string with parameterized [kerneltype][kernel_types] such as:
#' `"DoG:0,0,2"` or `"Diamond"`
#' @param iterations number of iterations
#' @param scaling string with kernel scaling. The special flag `"!"` automatically scales to full
#' dynamic range, for example: \code{"50\%!"}
#' @param bias output bias string, for example \code{"50\%"}
#' @examples if(magick_config()$version > "6.8.8")
#' image_convolve(logo)
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
