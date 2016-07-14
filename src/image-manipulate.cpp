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
XPtrImage magick_image_background( XPtrImage image, Rcpp::String color){
  for_each ( image->begin(), image->end(), Magick::backgroundColorImage(Magick::Color(color.get_cstring())));
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_matte( XPtrImage image, bool matte, Rcpp::String color){
  for_each ( image->begin(), image->end(), Magick::matteImage(matte));
  if(strlen(color.get_cstring()))
    for_each ( image->begin(), image->end(), Magick::matteColorImage(color.get_cstring()));
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_pen( XPtrImage image, Rcpp::String color){
  if(strlen(color.get_cstring()))
    for_each ( image->begin(), image->end(), Magick::penColorImage(color.get_cstring()));
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_crop( XPtrImage image, Rcpp::String geometry){
  const char * geom = geometry.get_cstring();
  if(strlen(geom)){
    for_each (image->begin(), image->end(), Magick::cropImage(geom));
  } else {
    for_each (image->begin(), image->end(), Magick::cropImage(image->front().size()));
  }
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_scale( XPtrImage image, Rcpp::String geometry){
  const char * geom = geometry.get_cstring();
  if(strlen(geom)){
    for_each (image->begin(), image->end(), Magick::scaleImage(geom));
  } else {
    for_each (image->begin(), image->end(), Magick::scaleImage(image->front().size()));
  }
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
