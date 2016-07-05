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
Rcpp::RawVector  magick_image_write( XPtrImage img, Rcpp::String format){
  Magick::Image image = *img;
  Magick::Blob output;
  if(strlen(format.get_cstring()))
    image.magick( format );
  image.write( &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}

// [[Rcpp::export]]
Rcpp::List  magick_image_info( XPtrImage img){
  Magick::Image image = *img;
  return Rcpp::List::create(
    Rcpp::_["size"] = Rcpp::String(image.size()),
    Rcpp::_["density"] = Rcpp::String(image.density()),
    Rcpp::_["page"] = Rcpp::String(image.page()),
    Rcpp::_["font"] = Rcpp::String(image.font()),
    Rcpp::_["quality"] = image.quality(),
    Rcpp::_["filesize"] = image.fileSize(),
    Rcpp::_["format"] = image.format(),
    Rcpp::_["magick"] = image.magick()
  );
}
