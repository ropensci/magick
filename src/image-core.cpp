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
    size_t x = index[i];
    if(x < 1 || x > image->size())
      throw std::runtime_error("subscript out of bounds");
  }
  Image *out = new Image;
  out->reserve(index.length());
  for(int i = 0; i < index.size(); i++){
    size_t x = index[i];
    Frame frame = (*image)[x-1]; //1 based indexing ;)
    out->insert(out->end(), frame);
  }
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}
