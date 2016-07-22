/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

//External R pointer finalizer
void finalize_image( Image *image ){
  delete image;
}

// [[Rcpp::export]]
int magick_image_length(XPtrImage image){
  return image->size();
}

// [[Rcpp::export]]
XPtrImage create (int len){
  Image *image = new Image;
  if(len > 0){
    image->reserve(len);
  }
  XPtrImage ptr(image);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

XPtrImage create (){
  return create (0);
}

// [[Rcpp::export]]
XPtrImage copy (XPtrImage image){
  Image *out = new Image(*image);
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_rev(XPtrImage input){
  XPtrImage output = create(input->size());
  for(Image::reverse_iterator i = input->rbegin();i != input->rend(); ++i){
    output->insert(output->end(), *i);
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_join(Rcpp::List input){
  int outlen = 0;
  for(int i = 0; i < input.length(); i++){
    XPtrImage x = input[i];
    outlen += x->size();
  }
  XPtrImage output = create(outlen);
  for(int i = 0; i < input.length(); i++){
    XPtrImage x = input[i];
    output->insert(output->end(), x->begin(), x->end());
  }
  return output;
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
  XPtrImage output = create(index.length());
  for(int i = 0; i < index.size(); i++){
    size_t x = index[i];
    Frame frame = (*image)[x-1]; //1 based indexing ;)
    output->insert(output->end(), frame);
  }
  return output;
}

// [[Rcpp::export]]
bool autobrewed(){
#ifdef BUILD_AUTOBREW
  return true;
#else
  return false;
#endif
}
