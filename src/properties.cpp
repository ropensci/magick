#include "magick_types.h"

// [[Rcpp::export]]
Rcpp::DataFrame magick_image_properties( XPtrImage input){
  MagickCore::Image * image = input->front().image();
  MagickCore::ResetImagePropertyIterator(image);
  const char * prop = NULL;
  std::vector<std::string> properties;
  while((prop = GetNextImageProperty(image)))
    properties.push_back(prop);
  Rcpp::CharacterVector names(properties.size());
  Rcpp::CharacterVector values(properties.size());
  for(size_t i = 0; i < properties.size(); i++){
    names.at(i) = properties.at(i);
    values.at(i) = MagickCore::GetImageProperty(image, properties.at(i).c_str());
  }
  return Rcpp::DataFrame::create(
    Rcpp::_["property"] = properties,
    Rcpp::_["value"] = values,
    Rcpp::_["stringsAsFactors"] = false
  );
}
