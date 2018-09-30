/* Jeroen Ooms (2018)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

// [[Rcpp::export]]
XPtrImage magick_image_edge( XPtrImage input, size_t radius){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::edgeImage(radius));
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_houghline( XPtrImage input, std::string geomstr,
                                  std::string col, std::string bg, double lwd){
  Magick::Geometry geom(Geom(geomstr.c_str()));
  XPtrImage output = copy(input);
  for(size_t i = 0; i < output->size(); i++){
    output->at(i).strokeColor(Magick::Color(col.c_str()));
    output->at(i).backgroundColor(Magick::Color(bg.c_str()));
    output->at(i).strokeWidth(lwd);
    output->at(i).houghLine(geom.width(), geom.height(), geom.xOff());
  }
  return output;
}
