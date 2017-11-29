/* Jeroen Ooms (2017)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

// [[Rcpp::export]]
XPtrImage magick_image_contrast( XPtrImage input, size_t sharpen){
  XPtrImage output = copy(input);
  for_each(output->begin(), output->end(), Magick::contrastImage(sharpen));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_normalize( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::normalizeImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_modulate( XPtrImage input, double brightness, double saturation, double hue){
  XPtrImage output = copy(input);
  for_each(output->begin(), output->end(), Magick::modulateImage(brightness, saturation, hue));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_map( XPtrImage input, XPtrImage map_image, bool dither){
  XPtrImage output = copy(input);
  if(map_image->size())
    mapImages(output->begin(), output->end(), map_image->front(), dither);
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_channel( XPtrImage input, const char * channel){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::channelImage(Channel(channel)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_colorize( XPtrImage input, const size_t opacity, const char * color){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::colorizeImage(opacity, Color(color)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_enhance( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::enhanceImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_equalize( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::equalizeImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_median( XPtrImage input, double radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::myMedianImage(radius));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_quantize( XPtrImage input, size_t max, Rcpp::CharacterVector space,
                                 Rcpp::LogicalVector dither, Rcpp::IntegerVector depth){
  XPtrImage output = copy(input);
  if(space.size())
    for_each ( output->begin(), output->end(), Magick::quantizeColorSpaceImage(ColorSpace(space.at(0))));
  if(dither.size())
    for_each ( output->begin(), output->end(), Magick::quantizeDitherImage(dither.at(0)));
  if(depth.size())
    for_each ( output->begin(), output->end(), Magick::quantizeTreeDepthImage(depth.at(0)));

  //quantize!
  for_each ( output->begin(), output->end(), Magick::quantizeColorsImage(max));
  for_each ( output->begin(), output->end(), Magick::quantizeImage(false));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_transparent( XPtrImage input, const char * color, double fuzz_percent){
  double fuzz = fuzz_pct_to_abs(fuzz_percent);
  XPtrImage output = copy(input);
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(fuzz));
  for_each ( output->begin(), output->end(), Magick::transparentImage(Color(color)));
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(input->front().colorFuzz()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_background( XPtrImage input, const char * color){
  XPtrImage output = copy(input);
  for_each (output->begin(), output->end(), Magick::backgroundColorImage(Color(color)));
  return output;
}
