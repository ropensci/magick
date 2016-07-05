#include <Rcpp.h>
#include <Magick++.h>
void finalize_image( Magick::Image* img );
typedef Rcpp::XPtr<Magick::Image, Rcpp::PreserveStorage, finalize_image> XPtrImage;
