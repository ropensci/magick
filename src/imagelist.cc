#include "magick_types.h"
#include <list>

//External R pointer finalizer
void finalize_image_list( std::list<Magick::Image> *imageList ){
  delete imageList;
}

// [[Rcpp::export]]
XPtrImageList magick_imagelist_create(Rcpp::List inputList){
  std::list<Magick::Image> *imageList = new std::list<Magick::Image>;
  for(int i = 0; i < inputList.length(); i++){
    Rcpp::XPtr<Magick::Image> image = inputList[i];
    if(!image.inherits("magick-image"))
      throw std::runtime_error("List contains object that is not a magick-image.");
    imageList->push_back(*image);
  }
  XPtrImageList ptr(imageList);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image-list");
  return ptr;
}

// [[Rcpp::export]]
Rcpp::RawVector magick_imagelist_write( XPtrImageList images, Rcpp::String format, int delay){
  std::list<Magick::Image> imageList = *images;
  if(strlen(format.get_cstring()))
    for_each ( imageList.begin(), imageList.end(), Magick::magickImage(format));
  for_each ( imageList.begin(), imageList.end(), Magick::animationDelayImage(delay));
  Magick::Blob output;
  writeImages( imageList.begin(), imageList.end(),  &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}
