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
