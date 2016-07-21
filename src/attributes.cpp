/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

#define Option(type, val) MagickCore::CommandOptionToMnemonic(type, val);

// [[Rcpp::export]]
Rcpp::IntegerVector magick_attr_delay( XPtrImage input, int delay){
  for_each ( input->begin(), input->end(), Magick::animationDelayImage(delay));
  Rcpp::IntegerVector out(input->size());
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->animationDelay());
  return out;
}

// [[Rcpp::export]]
XPtrImage magick_image_verbose( XPtrImage input){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::verboseImage(true));
  return output;
}

// [[Rcpp::export]]
Rcpp::DataFrame magick_image_info( XPtrImage input){
  int len = input->size();
  Rcpp::CharacterVector format(len);
  Rcpp::CharacterVector colorspace(len);
  Rcpp::IntegerVector width(len);
  Rcpp::IntegerVector height(len);
  Rcpp::IntegerVector colors(len);
  Rcpp::IntegerVector filesize(len);
  for(int i = 0; i < len; i++){
    Frame frame = input->at(i);
    colorspace[i] = Option(MagickCore::MagickColorspaceOptions, frame.colorSpace());
    Magick::Geometry geom(frame.size());
    format[i] = std::string(frame.magick());
    width[i] = geom.width();
    height[i] = geom.height();
    filesize[i] = frame.fileSize();
    colors[i] = frame.totalColors();
  }
  return Rcpp::DataFrame::create(
    Rcpp::_["format"] = format,
    Rcpp::_["height"] = height,
    Rcpp::_["width"] = width,
    Rcpp::_["colors"] = colors,
    Rcpp::_["colorspace"] = colorspace,
    Rcpp::_["filesize"] = filesize,
    Rcpp::_["stringsAsFactors"] = false
  );
}
