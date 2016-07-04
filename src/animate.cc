#include <Rcpp.h>
#include <Magick++.h>
#include <list>

// [[Rcpp::export]]
Rcpp::RawVector animate(Rcpp::List list, Rcpp::String format, int animationDelay = 100){
  std::list<Magick::Image> imageList;
  for(int i = 0; i < list.length(); i++){
    Rcpp::RawVector x = list[i];
    Magick::Blob input( x.begin(), x.length());
    Magick::Image image( input );
    image.magick( format );
    image.animationDelay(animationDelay);
    imageList.push_back(image);
  }
  Magick::Blob output;
  writeImages( imageList.begin(), imageList.end(),  &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}

