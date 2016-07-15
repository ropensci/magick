#include <Rcpp.h>
#include <Magick++.h>
#include <list>

typedef Magick::Image Frame;
typedef std::vector<Frame> Image;

void finalize_frame(Frame *frame);
void finalize_image(Image *image);

typedef Rcpp::XPtr<Frame, Rcpp::PreserveStorage, finalize_frame> XPtrFrame;
typedef Rcpp::XPtr<Image, Rcpp::PreserveStorage, finalize_image> XPtrImage;

XPtrImage copy (XPtrImage image);
