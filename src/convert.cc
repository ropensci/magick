#include <Magick++.h>
#include <Rcpp.h>
#include <iostream>
using namespace std;
using namespace Magick;

// [[Rcpp::export]]
Rcpp::RawVector convert_to(Rcpp::RawVector x, Rcpp::String to){
  //Magick::InitializeMagick();
  Blob input( x.begin(), x.length());
  Image image( input );
  Blob output;
  image.magick( to ); // Set JPEG output format
  image.write( &output );
  Rcpp::RawVector res(output.length());
  std::memcpy(res.begin(), output.data(), output.length());
  return res;
}
