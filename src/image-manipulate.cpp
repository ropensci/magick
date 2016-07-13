/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"
#include <list>

// [[Rcpp::export]]
XPtrImage magick_image_delay( XPtrImage image, int delay){
  for_each ( image->begin(), image->end(), Magick::animationDelayImage(delay));
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_format( XPtrImage image, Rcpp::String format){
  for_each ( image->begin(), image->end(), Magick::magickImage(format.get_cstring()));
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_trim( XPtrImage image){
  for_each ( image->begin(), image->end(), Magick::trimImage());
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_border( XPtrImage image, Rcpp::String color, Rcpp::String geometry){
  //need to set color before adding the border!
  if(strlen(color.get_cstring()))
    for_each ( image->begin(), image->end(), Magick::borderColorImage(color.get_cstring()));
  if(strlen(geometry.get_cstring()))
    for_each ( image->begin(), image->end(), Magick::borderImage(geometry.get_cstring()));
  return image;
}
