#define R_NO_REMAP
#include <Rcpp.h>
#include <Magick++.h>
#include <list>

typedef Magick::Image Frame;
typedef std::vector<Frame> Image;

void finalize_frame(Frame *frame);
void finalize_image(Image *image);

typedef Rcpp::XPtr<Frame, Rcpp::PreserveStorage, finalize_frame> XPtrFrame;
typedef Rcpp::XPtr<Image, Rcpp::PreserveStorage, finalize_image> XPtrImage;
typedef Image::iterator Iter;

XPtrImage create ();
XPtrImage create (int len);
XPtrImage copy (XPtrImage image);
