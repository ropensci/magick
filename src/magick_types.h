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

//IM 6~7 compatiblity
#if MagickLibVersion >= 0x700
Magick::Point Point(const char * str);
#define container vector
#define myAntiAliasImage textAntiAliasImage
#define myAntiAlias textAntiAlias
#define myDrawableDashArray DrawableStrokeDashArray
#define myMedianImage medianConvolveImage
#define myFilterType FilterType
#define myUndefinedMetric UndefinedErrorMetric
#define myRedQ quantumRed
#define myGreenQ quantumGreen
#define myBlueQ quantumBlue
#define myAlphaQ quantumAlpha
#else
#define container list
#define Point Geom
#define myAntiAliasImage antiAliasImage
#define myAntiAlias antiAlias
#define myDrawableDashArray DrawableDashArray
#define myMedianImage medianFilterImage
#define myFilterType FilterTypes
#define myUndefinedMetric UndefinedMetric
#define myRedQ redQuantum
#define myGreenQ greenQuantum
#define myBlueQ blueQuantum
#define myAlphaQ alphaQuantum
#endif

// Option parsers
Magick::Geometry Geom(size_t width, size_t height, size_t x, size_t y);
Magick::Geometry Geom(size_t width, size_t height);
Magick::Geometry Geom(const char * str);
Magick::Color Color(const char * str);
Magick::DisposeType Dispose(const char * str);
Magick::CompositeOperator Composite(const char * str);
Magick::ColorspaceType ColorSpace(const char * str);
Magick::myFilterType Filter(const char * str);
Magick::ChannelType Channel(const char * str);
