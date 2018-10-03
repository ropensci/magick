#include "magick_types.h"


// [[Rcpp::export]]
XPtrImage magick_image_fuzzycmeans( XPtrImage input, const double min_pixels=1.0, const double smoothing=1.5){
  XPtrImage output = copy(input);
  for(size_t i = 0; i < output->size(); i++)
    output->at(i).segment(min_pixels, smoothing);
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_connect( XPtrImage input, const size_t connectivity=4){
#if MagickLibVersion >= 0x690
  XPtrImage output = copy(input);
  for(size_t i = 0; i < output->size(); i++){
    output->at(i).connectedComponents(connectivity);
    output->at(i).autoLevel();
  }
  return output;
#else
  throw std::runtime_error("image_connect requires at least imagemagick 6.9.0");
#endif
}


