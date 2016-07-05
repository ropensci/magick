#include <Rcpp.h>
#include <Magick++.h>
#include <list>

void finalize_image( Magick::Image* image );
void finalize_image_list( std::list<Magick::Image> *imageList );

typedef Rcpp::XPtr<Magick::Image, Rcpp::PreserveStorage, finalize_image> XPtrImage;
typedef Rcpp::XPtr<std::list<Magick::Image>, Rcpp::PreserveStorage, finalize_image_list> XPtrImageList;
