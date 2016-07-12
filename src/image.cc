#include "magick_types.h"
#include <list>

//External R pointer finalizer
void finalize_image( Image *image ){
  delete image;
}

// [[Rcpp::export]]
XPtrImage magick_image_read(Rcpp::RawVector x){
  Image *image = new Image;
  Magick::Blob input( x.begin(), x.length());
  Magick::readImages( image, input );
  XPtrImage ptr(image);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_create(Rcpp::List inputList){
  Image *image = new Image;
  for(int i = 0; i < inputList.length(); i++){
    XPtrFrame frame = inputList[i];
    if(!frame.inherits("magick-frame"))
      throw std::runtime_error("List contains object that is not a magick-image.");
    image->push_back(*frame);
  }
  XPtrImage ptr(image);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
Rcpp::RawVector magick_image_write( XPtrImage image, Rcpp::String format, int delay){
  if(strlen(format.get_cstring()))
    for_each ( image->begin(), image->end(), Magick::magickImage(format));
  for_each ( image->begin(), image->end(), Magick::animationDelayImage(delay));
  Magick::Blob output;
  writeImages( image->begin(), image->end(),  &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}
