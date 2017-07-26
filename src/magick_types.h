#define R_NO_REMAP
#include <Rcpp.h>
#include <Magick++.h>
#include <list>

typedef Magick::Image Frame;
typedef std::vector<Frame> Image;

//typedef Rcpp::XPtr<Frame, Rcpp::PreserveStorage, finalize_frame> XPtrFrame;
//void finalize_frame(Frame *frame);

void finalize_image(Image *image);
typedef Rcpp::XPtr<Image, Rcpp::PreserveStorage, finalize_image, true> XPtrImage;
typedef Image::iterator Iter;

XPtrImage create ();
XPtrImage create (int len);
XPtrImage copy (XPtrImage image);

// Option parsers
Magick::Geometry Geom(size_t width, size_t height, size_t x, size_t y);
Magick::Geometry Geom(size_t width, size_t height);
Magick::Geometry Geom(const char * str);
Magick::Color Color(const char * str);
Magick::DisposeType Dispose(const char * str);
Magick::CompositeOperator Composite(const char * str);
