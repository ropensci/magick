/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"
#include <list>

//External R pointer finalizer
void finalize_image( Image *image ){
  delete image;
}

// [[Rcpp::export]]
XPtrImage magick_image_read(Rcpp::RawVector x){
  Image *image = new Image;
  Magick::readImages(image, Magick::Blob(x.begin(), x.length()));
  XPtrImage ptr(image);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_read_list(Rcpp::List list){
  Image *image = new Image;
  for(int i = 0; i < list.size(); i++) {
    if(TYPEOF(list[i]) != RAWSXP)
      throw std::runtime_error("magick_image_read_list can only read raw vectors");
    Rcpp::RawVector x = list[i];
    Magick::readImages(image, Magick::Blob(x.begin(), x.length()));
  }
  XPtrImage ptr(image);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
int magick_image_length(XPtrImage image){
  return image->size();
}

// [[Rcpp::export]]
XPtrImage magick_image_join(Rcpp::List input){
  int len = 0;
  for(int i = 0; i < input.length(); i++){
    XPtrImage x = input[i];
    len += x->size();
  }
  Image *image = new Image;
  image->reserve(len);
  for(int i = 0; i < input.length(); i++){
    XPtrImage x = input[i];
    image->insert(image->end(), x->begin(), x->end());
  }
  XPtrImage ptr(image);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_subset(XPtrImage image, Rcpp::IntegerVector index){
  //validate valid indices
  //TODO: support negative index for dropping frames
  for(int i = 0; i < index.size(); i++){
    int x = index[i];
    if(x < 1 || x > image->size())
      throw std::runtime_error("subscript out of bounds");
  }
  Image *out = new Image;
  out->reserve(index.length());
  for(int i = 0; i < index.size(); i++){
    int x = index[i];
    Frame frame = (*image)[x-1]; //1 based indexing ;)
    out->insert(out->end(), frame);
  }
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

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

// [[Rcpp::export]]
Rcpp::RawVector magick_image_write( XPtrImage image){
  Magick::Blob output;
  writeImages( image->begin(), image->end(),  &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
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
