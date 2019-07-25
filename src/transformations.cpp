/* Jeroen Ooms (2018)
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

Magick::ImageType Type(const char * str){
  ssize_t val = MagickCore::ParseCommandOption( MagickCore::MagickTypeOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid ImageType value: ") + str);
  return (Magick::ImageType) val;
}

Magick::ColorspaceType ColorSpace(const char * str){
  ssize_t val = MagickCore::ParseCommandOption( MagickCore::MagickColorspaceOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid ColorspaceType value: ") + str);
  return (Magick::ColorspaceType) val;
}

Magick::NoiseType Noise(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickNoiseOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid NoiseType value: ") + str);
  return (Magick::NoiseType) val;
}

Magick::ChannelType Channel(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickChannelOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid ChannelType value: ") + str);
  return (Magick::ChannelType) val;
}

Magick::myFilterType Filter(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickFilterOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid FilterType value: ") + str);
  return (Magick::myFilterType) val;
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

Magick::OrientationType Orientation(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickOrientationOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid OrientationType value: ") + str);
  return (Magick::OrientationType) val;
}

Magick::StyleType FontStyle(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickStyleOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid StyleType value: ") + str);
  return (Magick::StyleType) val;
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
#if MagickLibVersion >= 0x700
  for(size_t i = 0; i < output->size(); i++){
    MagickCore::Image *im = output->at(i).image();
    Magick::ChannelType old = MagickCore::SetImageChannelMask(im, Magick::ChannelType(Magick::CompositeChannels ^ Magick::AlphaChannel));
    output->at(i).charcoal(radius, sigma);
    MagickCore::SetImageChannelMask(im, old);
  }
#else
  for_each ( output->begin(), output->end(), Magick::charcoalImage(radius, sigma));
#endif
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
XPtrImage magick_image_fill( XPtrImage input, const char * color, const char * point,
                             double fuzz_percent, Rcpp::CharacterVector border_color){
  XPtrImage output = copy(input);
  double fuzz = fuzz_pct_to_abs(fuzz_percent);
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage( fuzz ));
  if(border_color.size()){
    for_each ( output->begin(), output->end(), Magick::floodFillColorImage(
        Magick::Geometry(Geom(point)), Color(color), Color(border_color[0])));
  } else {
    for_each ( output->begin(), output->end(), Magick::floodFillColorImage(
        Magick::Geometry(Geom(point)), Color(color)));
  }
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(input->front().colorFuzz()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_negate( XPtrImage input){
  XPtrImage output = copy(input);
#if MagickLibVersion >= 0x700
  for(size_t i = 0; i < output->size(); i++)
    output->at(i).negateChannel(Magick::ChannelType(Magick::CompositeChannels ^ Magick::AlphaChannel));
#else
  for_each ( output->begin(), output->end(), Magick::negateImage());
#endif
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_oilpaint( XPtrImage input, size_t radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::oilPaintImage(radius));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_implode( XPtrImage input, double factor){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::implodeImage(factor));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_format( XPtrImage input, Rcpp::CharacterVector format, Rcpp::CharacterVector type,
                               Rcpp::CharacterVector space, Rcpp::IntegerVector depth, Rcpp::LogicalVector antialias,
                               Rcpp::LogicalVector matte){
  XPtrImage output = copy(input);
  if(antialias.size()){
    for (Iter it = output->begin(); it != output->end(); ++it)
      it->strokeAntiAlias(antialias.at(0));
    for_each ( output->begin(), output->end(), Magick::myAntiAliasImage(antialias.at(0)));
  }
  if(matte.size())
    for_each ( output->begin(), output->end(), Magick::myMatteImage(matte.at(0)));
  if(type.size())
    for_each ( output->begin(), output->end(), Magick::typeImage(Type(type.at(0))));
  if(space.size())
    for_each ( output->begin(), output->end(), Magick::colorSpaceImage(ColorSpace(space.at(0))));
  if(depth.size())
    for_each ( output->begin(), output->end(), Magick::depthImage(depth.at(0)));
  if(format.size())
    for_each ( output->begin(), output->end(), Magick::magickImage(std::string(format.at(0))));
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
XPtrImage magick_image_repage( XPtrImage input){
  XPtrImage output = copy(input);
  for_each (output->begin(), output->end(), Magick::pageImage(Magick::Geometry()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_orient( XPtrImage input, Rcpp::CharacterVector orientation){
  XPtrImage output = copy(input);
  for(size_t i = 0; i < output->size(); i++){
    if(orientation.length()){
      output->at(i).orientation(Orientation(orientation.at(0)));
    } else {
      //https://github.com/ImageMagick/ImageMagick/commit/b559cab
#if MagickLibVersion >= 0x686
      output->at(i).autoOrient();
#else
      Rcpp::warning("ImageMagick too old to support autoOrient (requires >= 6.8.6)");
#endif
    }
  }
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
XPtrImage magick_image_reducenoise( XPtrImage input, const size_t radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::reduceNoiseImage(radius));
  return output;
}
/* STL is broken for annotateImage.
 * https://github.com/ImageMagick/ImageMagick/commit/903e501876d405ffd6f9f38f5e72db9acc3d15e8
 */

// [[Rcpp::export]]
XPtrImage magick_image_annotate( XPtrImage input, Rcpp::CharacterVector text, const char * gravity,
                                 const char * location, double rot, double size, const char * font,
                                 const char * style, double weight, Rcpp::CharacterVector color,
                                 Rcpp::CharacterVector strokecolor, Rcpp::CharacterVector boxcolor){
  XPtrImage output = copy(input);
  typedef std::container<Magick::Drawable> drawlist;
  Magick::Geometry pos(location);
  double x = pos.xOff();
  double y = pos.yOff();
  drawlist draw;
  draw.push_back(Magick::DrawableGravity(Gravity(gravity)));
  draw.push_back(Magick::DrawableTextAntialias(true));
  if(strokecolor.size())
    draw.push_back(Magick::DrawableStrokeColor(Color(strokecolor[0])));
  if(color.size())
    draw.push_back(Magick::DrawableFillColor(Color(color[0])));
  if(boxcolor.size())
    draw.push_back(Magick::DrawableTextUnderColor(Color(boxcolor[0])));
  draw.push_back(Magick::DrawablePointSize(size));
  draw.push_back(Magick::DrawableFont(normalize_font(font), FontStyle(style), weight, Magick::NormalStretch));
  if(rot){
    //temorary move center for rotation and then back
    draw.push_back(Magick::DrawableTranslation(x, y));
    draw.push_back(Magick::DrawableRotation(rot));
    draw.push_back(Magick::DrawableTranslation(-x, -y));
  }
  int len = text.size();
  if(len == 1){
    draw.push_back(Magick::DrawableText(x, y, std::string(text[0]), "UTF-8"));
    for_each (output->begin(), output->end(), Magick::drawImage(draw));
  } else if(len > 1){
    for(size_t i = 0; i < output->size(); i++){
      draw.push_back(Magick::DrawableText(x, y, std::string(text[i % len]), "UTF-8"));
      output->at(i).draw(draw);
      draw.pop_back();
    }
  } else {
    throw std::runtime_error("Length of 'text' must be equal to images or 1");
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_compare( XPtrImage input, XPtrImage reference_image, const char  * metric, double fuzz_percent){
#if MagickLibVersion < 0x687
  throw std::runtime_error("imagemagick too old does not support compare metrics");
#else
  XPtrImage output = copy(input);
  Rcpp::NumericVector distortion(input->size());
  Magick::MetricType compare_metric = strlen(metric) ? Metric(metric) : Magick::myUndefinedMetric;
  for_each ( output->begin(), output->end(), Magick::colorFuzzImage( fuzz_pct_to_abs(fuzz_percent) ));
  for(size_t i = 0; i < input->size(); i++){
    double val = 0;
    output->at(i) = output->at(i).compare(reference_image->front(), compare_metric, &val);
    distortion.at(i) = val;
  }
  for_each ( output->begin(), output->end(), Magick::colorFuzzImage( 0 ));
  output.attr("distortion") = distortion;
  return output;
#endif
}

