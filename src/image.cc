#include "magick_types.h"
#include <iostream>

//External R pointer finalizer
void finalize_image( Magick::Image* image ){
  delete image;
}

// [[Rcpp::export]]
XPtrImage magick_image_read(Rcpp::RawVector x){
  Magick::Blob input( x.begin(), x.length());
  Magick::Image *image = new Magick::Image( input );
  XPtrImage ptr(image);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
Rcpp::RawVector  magick_image_write( Rcpp::XPtr<Magick::Image> img, Rcpp::String format){
  Magick::Image image = *img;
  Magick::Blob output;
  image.magick( format ); // Set output format
  image.write( &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}
