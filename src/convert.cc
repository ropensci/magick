#include <Rcpp.h>
#include <Magick++.h>
#include <iostream>

// [[Rcpp::export]]
Rcpp::RawVector convert_to(Rcpp::RawVector x, Rcpp::String to){
  //Magick::InitializeMagick();
  Magick::Blob input( x.begin(), x.length());
  Magick::Image image( input );
  Magick::Blob output;
  image.magick( to ); // Set JPEG output format
  image.write( &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}
