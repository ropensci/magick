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


// https://github.com/ImageMagick/ImageMagick6/commit/acfd403ca7ca38c3a06bdd81ca5b4e41b12e11bf

// [[Rcpp::export]]
XPtrImage magick_image_canny( XPtrImage input, std::string geomstr){
#if MagickLibVersion >= 0x689
  Magick::Geometry geom(Geom(geomstr.c_str()));
  if(!geom.percent())
    throw std::runtime_error("Canny edge upper/lower must be specified in percentage");
  double radius = geom.width();
  double sigma = geom.height();
  double lower = geom.xOff() / 100.0;
  double upper = geom.yOff() / 100.0;
  XPtrImage output = copy(input);
  for(size_t i = 0; i < output->size(); i++)
    output->at(i).cannyEdge(radius, sigma, lower, upper);
  return output;
#else
  throw std::runtime_error("cany edge not supported, ImageMagick too old");
#endif
}

// [[Rcpp::export]]
XPtrImage magick_image_houghline( XPtrImage input, std::string geomstr,
                                  std::string col, std::string bg, double lwd){
#if MagickLibVersion >= 0x689
  Magick::Geometry geom(Geom(geomstr.c_str()));
  XPtrImage output = copy(input);
  for(size_t i = 0; i < output->size(); i++){
    output->at(i).strokeColor(Magick::Color(col.c_str()));
    output->at(i).backgroundColor(Magick::Color(bg.c_str()));
    output->at(i).strokeWidth(lwd);
    output->at(i).houghLine(geom.width(), geom.height(), geom.xOff());
  }
  return output;
#else
  throw std::runtime_error("houghline not supported, ImageMagick too old");
#endif
}
