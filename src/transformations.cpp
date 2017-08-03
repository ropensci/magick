/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

Magick::Geometry Geom(size_t width, size_t height, size_t x, size_t y){
  Magick::Geometry geom(width, height, x, y);
  if(!geom.isValid())
    throw std::runtime_error(std::string("Invalid geometry dimensions"));
  return geom;
}

Magick::Geometry Geom(size_t width, size_t height){
  Magick::Geometry geom(width, height);
  if(!geom.isValid())
    throw std::runtime_error(std::string("Invalid geometry dimensions"));
  return geom;
}

Magick::Geometry Geom(const char * str){
  Magick::Geometry geom(str);
  if(!geom.isValid())
    throw std::runtime_error(std::string("Invalid geometry string: ") + str);
  return geom;
}

Magick::GravityType Gravity(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickGravityOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid GravityType value: ") + str);
  return (Magick::GravityType) val;
}

Magick::NoiseType Noise(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickNoiseOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid NoiseType value: ") + str);
  return (Magick::NoiseType) val;
}

#if MagickLibVersion >= 0x687
Magick::MetricType Metric(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickMetricOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid MetricType value: ") + str);
  return (Magick::MetricType) val;
}
#endif

Magick::CompositeOperator Composite(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickComposeOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid CompositeOperator value: ") + str);
  return (Magick::CompositeOperator) val;
}

Magick::DisposeType Dispose(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickDisposeOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid DisposeType value: ") + str);
  return (Magick::DisposeType) val;
}

Magick::Color Color(const char * str){
  Magick::Color val(str);
  if(!val.isValid())
    throw std::runtime_error(std::string("Invalid Color value: ") + str);
  return val;
}

#if MagickLibVersion >= 0x700
Magick::Point Point(const char * str){
  Magick::Point point(str);
  if(!point.isValid())
    throw std::runtime_error(std::string("Invalid point string: ") + str);
  return point;
}
#endif

// [[Rcpp::export]]
XPtrImage magick_image_noise( XPtrImage input, const char * noisetype){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::addNoiseImage(Noise(noisetype)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_blur( XPtrImage input, const double radius = 1, const double sigma = 0.5){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::blurImage(radius, sigma));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_charcoal( XPtrImage input, const double radius = 1, const double sigma = 0.5){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::charcoalImage(radius, sigma));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_chop( XPtrImage input, const char * geometry){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::chopImage(Geom(geometry)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_colorize( XPtrImage input, const size_t opacity, const char * color){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::colorizeImage(opacity, Color(color)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_edge( XPtrImage input, size_t radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::edgeImage(radius));
  return output;
}

/* Added in f78d1802df605fe2a0bd2551f4e4a27702e12828 */
// [[Rcpp::export]]
XPtrImage magick_image_deskew( XPtrImage input, double treshold){
  XPtrImage output = copy(input);
#if MagickLibVersion >= 0x686
  for (Iter it = output->begin(); it != output->end(); ++it)
    it->deskew(treshold);
#else
  throw std::runtime_error("deskew not supported, ImageMagick too old");
#endif
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_emboss( XPtrImage input, const double radius = 1, const double sigma = 0.5){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::embossImage(radius, sigma));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_enhance( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::enhanceImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_equalize( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::equalizeImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_flip( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::flipImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_flop( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::flopImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_fill( XPtrImage input, const char * color, const char * point, double fuzz){
  XPtrImage output = copy(input);
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(fuzz));
  for_each ( output->begin(), output->end(), Magick::floodFillColorImage(
      Magick::Geometry(Geom(point)), Color(color)));
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(input->front().colorFuzz()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_transparent( XPtrImage input, const char * color, double fuzz){
  XPtrImage output = copy(input);
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(fuzz));
  Rprintf("set fuzz to %f\n", fuzz);
  for_each ( output->begin(), output->end(), Magick::transparentImage(Color(color)));
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(input->front().colorFuzz()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_frame( XPtrImage input, const char * geometry){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::frameImage(Geom(geometry)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_negate( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::negateImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_normalize( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::normalizeImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_oilpaint( XPtrImage input, size_t radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::oilPaintImage(radius));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_rotate( XPtrImage input, double degrees){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::rotateImage(degrees));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_implode( XPtrImage input, double factor){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::implodeImage(factor));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_format( XPtrImage input, const char * format, Rcpp::IntegerVector depth,
                               Rcpp::LogicalVector antialias){
  XPtrImage output = copy(input);
  if(depth.size())
    for_each ( output->begin(), output->end(), Magick::depthImage(depth.at(0)));
  if(antialias.size()){
    for (Iter it = output->begin(); it != output->end(); ++it)
      it->strokeAntiAlias(antialias.at(0));
    for_each ( output->begin(), output->end(), Magick::myAntiAliasImage(antialias.at(0)));
  }
  for_each ( output->begin(), output->end(), Magick::magickImage(format));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_trim( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::trimImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_composite( XPtrImage input, XPtrImage composite_image,
                                  const char * offset, const char * composite){
  XPtrImage output = copy(input);
  if(composite_image->size()){
    for_each(output->begin(), output->end(), Magick::compositeImage(composite_image->front(),
      Geom(offset), Composite(composite)));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_contrast( XPtrImage input, size_t sharpen){
  XPtrImage output = copy(input);
  for_each(output->begin(), output->end(), Magick::contrastImage(sharpen));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_background( XPtrImage input, const char * color){
  XPtrImage output = copy(input);
  for_each (output->begin(), output->end(), Magick::backgroundColorImage(Color(color)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_page( XPtrImage input, Rcpp::CharacterVector pagesize, Rcpp::CharacterVector density){
  XPtrImage output = copy(input);
  if(pagesize.size())
    for_each (output->begin(), output->end(), Magick::pageImage(Geom(pagesize[0])));
  if(density.size())
  for_each (output->begin(), output->end(), Magick::densityImage(Point(density[0])));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_crop( XPtrImage input, const char * geometry){
  XPtrImage output = copy(input);
  if(std::strlen(geometry)){
    for_each (output->begin(), output->end(), Magick::cropImage(Geom(geometry)));
  } else {
    if(input->size())
      for_each (output->begin(), output->end(), Magick::cropImage(input->front().size()));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_scale( XPtrImage input, const char * geometry){
  XPtrImage output = copy(input);
  if(strlen(geometry)){
    for_each (output->begin(), output->end(), Magick::scaleImage(Geom(geometry)));
  } else {
    if(input->size())
      for_each (output->begin(), output->end(), Magick::scaleImage(input->front().size()));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_sample( XPtrImage input, const char * geometry){
  XPtrImage output = copy(input);
  if(strlen(geometry)){
    for_each (output->begin(), output->end(), Magick::sampleImage(Geom(geometry)));
  } else {
    if(input->size())
      for_each (output->begin(), output->end(), Magick::sampleImage(input->front().size()));
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_border( XPtrImage input, const char * color, const char * geometry){
  XPtrImage output = copy(input);
  //need to set color before adding the border!
  if(strlen(color))
    for_each ( output->begin(), output->end(), Magick::borderColorImage(color));
  if(strlen(geometry))
    for_each ( output->begin(), output->end(), Magick::borderImage(Geom(geometry)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_despeckle( XPtrImage input, int times){
  XPtrImage output = copy(input);
  for (int i=0; i < times; i++) {
    for_each ( output->begin(), output->end(), Magick::despeckleImage());
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_median( XPtrImage input, double radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::myMedianImage(radius));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_reducenoise( XPtrImage input, const size_t radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::reduceNoiseImage(radius));
  return output;
}
/* STL is broken for annotateImage.
 * https://github.com/ImageMagick/ImageMagick/commit/903e501876d405ffd6f9f38f5e72db9acc3d15e8
 */

// [[Rcpp::export]]
XPtrImage magick_image_annotate( XPtrImage input, const std::string text, const char * gravity,
                                 const char * location, double degrees, Rcpp::IntegerVector size,
                                 Rcpp::CharacterVector font, Rcpp::CharacterVector color,
                                 Rcpp::CharacterVector strokecolor, Rcpp::CharacterVector boxcolor){
  XPtrImage output = copy(input);
  if(color.size())
    for_each ( output->begin(), output->end(), Magick::fillColorImage(Color(color[0])));
  if(strokecolor.size())
    for_each ( output->begin(), output->end(), Magick::strokeColorImage(Color(strokecolor[0])));
  if(boxcolor.size())
    for_each ( output->begin(), output->end(), Magick::boxColorImage(Color(boxcolor[0])));
  if(font.size())
    for_each ( output->begin(), output->end(), Magick::fontImage(std::string(font[0])));
  if(size.size())
    for_each ( output->begin(), output->end(), Magick::fontPointsizeImage(size[0]));
  for (Iter it = output->begin(); it != output->end(); ++it)
    it->annotate(text, Geom(location), Gravity(gravity), degrees);
  if(color.size())
    for_each ( output->begin(), output->end(), Magick::fillColorImage(input->front().fillColor()));
  if(strokecolor.size())
    for_each ( output->begin(), output->end(), Magick::strokeColorImage(input->front().strokeColor()));
  if(boxcolor.size())
    for_each ( output->begin(), output->end(), Magick::boxColorImage(input->front().boxColor()));
  if(font.size())
    for_each ( output->begin(), output->end(), Magick::fontImage(input->front().font()));
  if(size.size())
    for_each ( output->begin(), output->end(), Magick::fontPointsizeImage(fmin(10, input->front().fontPointsize())));
  return output;
}

// [[Rcpp::export]]
double magick_image_compare( XPtrImage input, XPtrImage reference_image, const char  * metric){
  if(strlen(metric)){
#if MagickLibVersion >= 0x687
    return input->front().compare(reference_image->front(), Metric(metric));
#else
    throw std::runtime_error("imagemagick too old, does not custom support metrics");
#endif
  } else {
    return input->front().compare(reference_image->front());
  }
}
