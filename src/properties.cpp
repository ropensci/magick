#include "magick_types.h"

// [[Rcpp::export]]
Rcpp::DataFrame magick_image_properties( XPtrImage input){
  Frame frame = input->front();
  MagickCore::Image * image = frame.image();
  MagickCore::ResetImagePropertyIterator(image);
  const char * prop = NULL;
  std::vector<std::string> properties;
  while((prop = GetNextImageProperty(image)))
    properties.push_back(prop);
  Rcpp::CharacterVector names(properties.size());
  Rcpp::CharacterVector values(properties.size());
  for(size_t i = 0; i < properties.size(); i++){
    names.at(i) = properties.at(i);
    values.at(i) = frame.attribute(properties.at(i));
  }
  return Rcpp::DataFrame::create(
    Rcpp::_["property"] = properties,
    Rcpp::_["value"] = values,
    Rcpp::_["stringsAsFactors"] = false
  );
}
