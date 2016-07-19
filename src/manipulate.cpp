/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

// [[Rcpp::export]]
XPtrImage magick_image_noise( XPtrImage input, int noisetype){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::addNoiseImage((Magick::NoiseType) noisetype));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_blur( XPtrImage input, const double radius = 1, const double sigma = 0.5){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::blurImage(radius, sigma));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_charcoal( XPtrImage input, const double radius = 1, const double sigma = 0.5){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::charcoalImage(radius, sigma));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_chop( XPtrImage input, Rcpp::String geometry){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::chopImage(geometry.get_cstring()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_colorize( XPtrImage input, const size_t opacity, Rcpp::String color){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::colorizeImage(opacity, color.get_cstring()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_edge( XPtrImage input, size_t radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::edgeImage(radius));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_emboss( XPtrImage input, const double radius = 1, const double sigma = 0.5){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::embossImage(radius, sigma));
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
XPtrImage magick_image_flip( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::flipImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_flop( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::flopImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_fill( XPtrImage input, Rcpp::String color, Rcpp::String point, double fuzz){
  XPtrImage output = copy(input);
  if(fuzz != 0){
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(fuzz));
  }
  for_each ( output->begin(), output->end(), Magick::floodFillColorImage(
      Magick::Geometry(point.get_cstring()), Magick::Color(color.get_cstring())));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_frame( XPtrImage input, Rcpp::String geometry){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::frameImage(geometry.get_cstring()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_negate( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::negateImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_normalize( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::normalizeImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_oilpaint( XPtrImage input, size_t radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::oilPaintImage(radius));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_rotate( XPtrImage input, double degrees){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::rotateImage(degrees));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_implode( XPtrImage input, double factor){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::implodeImage(factor));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_format( XPtrImage input, Rcpp::String format){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::magickImage(format.get_cstring()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_trim( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::trimImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_composite( XPtrImage input, XPtrImage composite_image, Rcpp::String offset, int op){
  XPtrImage output = copy(input);
  if(composite_image->size()){
    for_each(output->begin(), output->end(), Magick::compositeImage(composite_image->front(),
      Magick::Geometry(offset.get_cstring()), (Magick::CompositeOperator) op));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_contrast( XPtrImage input, size_t sharpen){
  XPtrImage output = copy(input);
  for_each(output->begin(), output->end(), Magick::contrastImage(sharpen));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_background( XPtrImage input, Rcpp::String color){
  XPtrImage output = copy(input);
  for_each (output->begin(), output->end(), Magick::backgroundColorImage(Magick::Color(color.get_cstring())));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_crop( XPtrImage input, Rcpp::String geometry){
  XPtrImage output = copy(input);
  const char * geom = geometry.get_cstring();
  if(strlen(geom)){
    for_each (output->begin(), output->end(), Magick::cropImage(geom));
  } else {
    if(input->size())
      for_each (output->begin(), output->end(), Magick::cropImage(input->front().size()));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_scale( XPtrImage input, Rcpp::String geometry){
  XPtrImage output = copy(input);
  const char * geom = geometry.get_cstring();
  if(strlen(geom)){
    for_each (output->begin(), output->end(), Magick::scaleImage(geom));
  } else {
    if(input->size())
      for_each (output->begin(), output->end(), Magick::scaleImage(input->front().size()));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_sample( XPtrImage input, Rcpp::String geometry){
  XPtrImage output = copy(input);
  const char * geom = geometry.get_cstring();
  if(strlen(geom)){
    for_each (output->begin(), output->end(), Magick::sampleImage(geom));
  } else {
    if(input->size())
      for_each (output->begin(), output->end(), Magick::sampleImage(input->front().size()));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_border( XPtrImage input, Rcpp::String color, Rcpp::String geometry){
  XPtrImage output = copy(input);
  //need to set color before adding the border!
  if(strlen(color.get_cstring()))
    for_each ( output->begin(), output->end(), Magick::borderColorImage(color.get_cstring()));
  if(strlen(geometry.get_cstring()))
    for_each ( output->begin(), output->end(), Magick::borderImage(geometry.get_cstring()));
  return output;
}


/* STL is broken for annotateImage.
 * https://github.com/ImageMagick/ImageMagick/commit/903e501876d405ffd6f9f38f5e72db9acc3d15e8
 */

// [[Rcpp::export]]
XPtrImage magick_image_annotate( XPtrImage input, const std::string text, Rcpp::String bbox, int gravity){
  XPtrImage output = copy(input);
  for(int i = 0; i < output->size(); i++){
    output->at(i).annotate(text, Magick::Geometry(bbox.get_cstring()), (Magick::GravityType) gravity);
  }
  return output;
}

