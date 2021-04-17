/* Jeroen Ooms (2018)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

// [[Rcpp::export]]
XPtrImage magick_image_contrast( XPtrImage input, size_t sharpen){
  XPtrImage output = copy(input);
  for_each(output->begin(), output->end(), Magick::contrastImage(sharpen));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_normalize( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::normalizeImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_modulate( XPtrImage input, double brightness, double saturation, double hue){
  XPtrImage output = copy(input);
  for_each(output->begin(), output->end(), Magick::modulateImage(brightness, saturation, hue));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_map( XPtrImage input, XPtrImage map_image, bool dither){
  XPtrImage output = copy(input);
  if(map_image->size())
    mapImages(output->begin(), output->end(), map_image->front(), dither);
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_channel( XPtrImage input, const char * channel){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::channelImage(Channel(channel)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_colorize( XPtrImage input, const size_t opacity, const char * color){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::colorizeImage(opacity, Color(color)));
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
XPtrImage magick_image_median( XPtrImage input, double radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::myMedianImage(radius));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_quantize( XPtrImage input, size_t max, Rcpp::CharacterVector space,
                                 Rcpp::LogicalVector dither, Rcpp::IntegerVector depth){
  XPtrImage output = copy(input);
  if(space.size())
    for_each ( output->begin(), output->end(), Magick::quantizeColorSpaceImage(ColorSpace(space.at(0))));
  if(dither.size())
    for_each ( output->begin(), output->end(), Magick::quantizeDitherImage(dither.at(0)));
  if(depth.size())
    for_each ( output->begin(), output->end(), Magick::quantizeTreeDepthImage(depth.at(0)));

  //quantize!
  for_each ( output->begin(), output->end(), Magick::quantizeColorsImage(max));
  for_each ( output->begin(), output->end(), Magick::quantizeImage(false));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_ordered_dither( XPtrImage input, std::string threshold_map){
  XPtrImage output = copy(input);
#if MagickLibVersion >= 0x689
  for(size_t i = 0; i < output->size(); i++)
    output->at(i).orderedDither(threshold_map);
#else
  Rcpp::warning("ImageMagick too old to support orderedDither (requires >= 6.8.9)");
#endif
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_transparent( XPtrImage input, const char * color, double fuzz_percent){
  double fuzz = fuzz_pct_to_abs(fuzz_percent);
  XPtrImage output = copy(input);
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(fuzz));
  for_each ( output->begin(), output->end(), Magick::transparentImage(Color(color)));
  if(fuzz != 0)
    for_each ( output->begin(), output->end(), Magick::colorFuzzImage(input->front().colorFuzz()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_background( XPtrImage input, const char * color){
  XPtrImage output = copy(input);
  for_each (output->begin(), output->end(), Magick::backgroundColorImage(Color(color)));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_lat( XPtrImage input, const char * geomstr){
  Magick::Geometry geom = Geom(geomstr);
  size_t width = geom.width();
  size_t height = geom.height();
  double offset =  geom.xOff();
  if(geom.percent())
    offset = fuzz_pct_to_abs(offset);
  XPtrImage output = copy(input);
  for_each (output->begin(), output->end(), Magick::adaptiveThresholdImage(width, height, offset));
  return output;
}

/* black/white threshold introduced Aug 1, 2013:
 * https://github.com/ImageMagick/ImageMagick6/commit/b6e7716bc753d9b4ee05823eb532a1df73f719d0
 */
// [[Rcpp::export]]
XPtrImage magick_image_threshold_black( XPtrImage input,  const std::string threshold, Rcpp::CharacterVector channel){
  XPtrImage output = copy(input);
#if MagickLibVersion >= 0x687
  if(channel.length()){
    Magick::ChannelType chan = Channel(std::string(channel.at(0)).c_str());
    for(size_t i = 0; i < output->size(); i++)
      output->at(i).blackThresholdChannel(chan, threshold);
  } else {
    for(size_t i = 0; i < output->size(); i++)
      output->at(i).blackThreshold(threshold);
  }
#else
  Rcpp::warning("ImageMagick too old to support whiteThreshold (requires >= 6.8.7)");
#endif
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_threshold_white( XPtrImage input,  const std::string threshold, Rcpp::CharacterVector channel){
  XPtrImage output = copy(input);
#if MagickLibVersion >= 0x687
  if(channel.length()){
    Magick::ChannelType chan = Channel(std::string(channel.at(0)).c_str());
    for(size_t i = 0; i < output->size(); i++)
      output->at(i).whiteThresholdChannel(chan, threshold);
  } else {
    for(size_t i = 0; i < output->size(); i++)
      output->at(i).whiteThreshold(threshold);
  }
#else
  Rcpp::warning("ImageMagick too old to support whiteThreshold (requires >= 6.8.7)");
#endif
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_level( XPtrImage input, double black_pct, double white_pct, double mid_point,
                              Rcpp::CharacterVector channel){
  XPtrImage output = copy(input);
  double black_point = fuzz_pct_to_abs(black_pct);
  double white_point = fuzz_pct_to_abs(white_pct);
  if(channel.length()){
    Magick::ChannelType chan = Channel(std::string(channel.at(0)).c_str());
    for(size_t i = 0; i < output->size(); i++)
      output->at(i).levelChannel(chan, black_point, white_point, mid_point);
  } else {
    for_each(output->begin(), output->end(), Magick::levelImage(black_point, white_point, mid_point));
  }
  return output;
}
