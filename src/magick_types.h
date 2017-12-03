#define R_NO_REMAP
#include <Rcpp.h>
#include <Magick++.h>
#include <list>

typedef Magick::Image Frame;
typedef std::vector<Frame> Image;

//typedef Rcpp::XPtr<Frame, Rcpp::PreserveStorage, finalize_frame> XPtrFrame;
//void finalize_frame(Frame *frame);

void finalize_image(Image *image);
typedef Rcpp::XPtr<Image, Rcpp::PreserveStorage, finalize_image, false> XPtrImage;
typedef Image::iterator Iter;

XPtrImage create ();
XPtrImage create (int len);
XPtrImage copy (XPtrImage image);

// Repage was introduced in 6.9.0-7 https://github.com/ImageMagick/ImageMagick/commit/919cb01
#if MagickLibVersion >= 0x691
#define myRepage() repage()
#else
#define myRepage() page(Magick::Geometry())
#endif

// Font utilities
std::string normalize_font(const char * family);

// Fuzz factor
#define MQD MAGICKCORE_QUANTUM_DEPTH
#define fuzz_pct_to_abs(x) ((x / 100 ) * (MQD * MQD * MQD * MQD + 1))

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
#define hasMatte() hasChannel(Magick::PixelChannel::AlphaPixelChannel)
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
#define hasMatte() matte()
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
