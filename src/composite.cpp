#include "magick_types.h"

/* Support for artifacts was added in 6.8.7: https://git.io/v7HFG
 */

Magick::Geometry apply_geom_gravity(Frame image, Magick::Geometry geom, Magick::GravityType gravity){
  MagickCore::RectangleInfo region(geom);
  MagickCore::GravityAdjustGeometry(image.columns(), image.rows(), gravity, &region);
  return region;
}

// [[Rcpp::export]]
XPtrImage magick_image_composite( XPtrImage input, XPtrImage composite_image,
                                  const char * offset, const char * composite, Rcpp::CharacterVector args){
  XPtrImage output = copy(input);
  if(args.size() && std::string(args.at(0)).length()){
#if MagickLibVersion >= 0x687
    for (Iter it = output->begin(); it != output->end(); ++it)
      it->artifact("compose:args", std::string(args.at(0)));
#else
    Rcpp::warning("ImageMagick too old to support composite_args (requires >= 6.8.7)");
#endif
  }
  if(composite_image->size()){
    //offset can be either geometry or gravity
    Magick::Geometry geom(offset);
    if(geom.isValid()){
      for_each(output->begin(), output->end(),
               Magick::compositeImage(composite_image->front(), geom, Composite(composite)));
    } else {
      for(size_t i = 0; i < output->size(); i++){
        output->at(i).composite(composite_image->front(), Gravity(offset), Composite(composite));
      }
    }
  }
  if(args.size() && std::string(args.at(0)).length()){
#if MagickLibVersion >= 0x687
    for (Iter it = output->begin(); it != output->end(); ++it)
      it->artifact("compose:args", "");
#endif
  }
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_border( XPtrImage input, Rcpp::CharacterVector color, Rcpp::CharacterVector geometry,
                               Rcpp::CharacterVector composite){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::composeImage(Composite(composite.at(0))));
  if(color.size())
    for_each ( output->begin(), output->end(), Magick::borderColorImage(Color(color.at(0))));
  if(geometry.size())
    for_each ( output->begin(), output->end(), Magick::borderImage(Geom(geometry.at(0))));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_frame( XPtrImage input, Rcpp::CharacterVector color, Rcpp::CharacterVector geometry){
  XPtrImage output = copy(input);
  if(color.size())
    for_each ( output->begin(), output->end(), Magick::matteColorImage(Color(color.at(0))));
  if(geometry.size())
    for_each ( output->begin(), output->end(), Magick::frameImage(Geom(geometry.at(0))));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_shadow_mask( XPtrImage input, const char * geomstr){
  XPtrImage output = copy(input);
#if MagickLibVersion >= 0x675
  Magick::Geometry geom = Geom(geomstr);
  const double opacity = geom.width();
  const double sigma = geom.height();
  const size_t x = geom.xOff();
  const size_t y = geom.yOff();
  for_each ( output->begin(), output->end(), Magick::shadowImage(opacity, sigma, x, y));
#else
  throw std::runtime_error("shadowImage not supported, ImageMagick too old");
#endif
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_crop( XPtrImage input, Rcpp::CharacterVector geometry,
                             Rcpp::CharacterVector gravity, bool repage){
  XPtrImage output = copy(input);
  for(size_t i = 0; i < output->size(); i++){
    Magick::Geometry region(geometry.size() ? Geom(geometry.at(0)) : input->front().size());
    if(gravity.size())
      region = apply_geom_gravity(output->at(i), region, Gravity(gravity.at(0)));
    output->at(i).crop(region);
  }
  if(repage)
    for_each ( output->begin(), output->end(), Magick::pageImage(Magick::Geometry()));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_extent( XPtrImage input, Rcpp::CharacterVector geometry,
                               Rcpp::CharacterVector gravity, Rcpp::CharacterVector color){
  XPtrImage output = copy(input);
  for(size_t i = 0; i < output->size(); i++){
    output->at(i).extent(Geom(geometry.at(0)), Color(color.at(0)), Gravity(gravity.at(0)));
  }
  return output;
}
