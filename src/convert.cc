#include <Rcpp.h>
#include <Magick++.h>
#include <iostream>

// [[Rcpp::export]]
Rcpp::RawVector convert_to(Rcpp::RawVector x, Rcpp::String format){
  //Magick::InitializeMagick();
  Magick::Blob input( x.begin(), x.length());
  Magick::Image image( input );
  Magick::Blob output;
  image.magick( format ); // Set output format
  image.write( &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}
