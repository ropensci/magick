#include "magick_types.h"
#include <list>

// [[Rcpp::export]]
Rcpp::RawVector magick_image_animage(Rcpp::List list, Rcpp::String format, Rcpp::IntegerVector animationDelay){
  std::list<Magick::Image> imageList;
  for(int i = 0; i < list.length(); i++){
    Rcpp::XPtr<Magick::Image> image = list[i];
    image->magick( format );
    image->animationDelay(animationDelay[i]);
    imageList.push_back(*image);
  }
  Magick::Blob output;
  writeImages( imageList.begin(), imageList.end(),  &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}

