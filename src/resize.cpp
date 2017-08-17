#include "magick_types.h"

// [[Rcpp::export]]
XPtrImage magick_image_scale( XPtrImage input, Rcpp::CharacterVector geometry){
  XPtrImage output = copy(input);
  if(geometry.size()){
    for_each (output->begin(), output->end(), Magick::scaleImage(Geom(geometry.at(0))));
  } else if(input->size()) {
    for_each (output->begin(), output->end(), Magick::scaleImage(input->front().size()));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_sample( XPtrImage input, Rcpp::CharacterVector geometry){
  XPtrImage output = copy(input);
  if(geometry.size()){
    for_each (output->begin(), output->end(), Magick::sampleImage(Geom(geometry.at(0))));
  } else if(input->size()){
    for_each (output->begin(), output->end(), Magick::sampleImage(input->front().size()));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_resize( XPtrImage input, Rcpp::CharacterVector geometry, Rcpp::CharacterVector filter){
  XPtrImage output = copy(input);
  if(filter.size())
    for_each (output->begin(), output->end(), Magick::filterTypeImage(Filter(filter.at(0))));
  if(geometry.size()){
    for_each (output->begin(), output->end(), Magick::resizeImage(Geom(geometry.at(0))));
  } else if(input->size()){
    for_each (output->begin(), output->end(), Magick::resizeImage(input->front().size()));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_rotate( XPtrImage input, double degrees){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::rotateImage(degrees));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_chop( XPtrImage input, const char * geometry){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::chopImage(Geom(geometry)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_trim( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::trimImage());
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
XPtrImage magick_image_crop( XPtrImage input, Rcpp::CharacterVector geometry){
  XPtrImage output = copy(input);
  if(geometry.size()){
    for_each (output->begin(), output->end(), Magick::cropImage(Geom(geometry.at(0))));
  } else if(input->size()){
    for_each (output->begin(), output->end(), Magick::cropImage(input->front().size()));
  }
  return output;
}
