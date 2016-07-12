#include "magick_types.h"

// [[Rcpp::export]]
Rcpp::List magick_coder_info(Rcpp::String format){
  Magick::CoderInfo info(format);
  return Rcpp::List::create(
    Rcpp::_["name"] = Rcpp::String(info.name()),
    Rcpp::_["description"] = Rcpp::String(info.description()),
    Rcpp::_["isReadable"] = Rcpp::String(info.isReadable()),
    Rcpp::_["isWritable"] = Rcpp::String(info.isWritable()),
    Rcpp::_["isMultiFrame"] = Rcpp::String(info.isMultiFrame())
  );
}
