#include "magick_types.h"

/* Support for artifacts was added in 6.8.7: https://git.io/v7HFG
 */

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
    for_each(output->begin(), output->end(), Magick::compositeImage(composite_image->front(),
                           Geom(offset), Composite(composite)));
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
