/* Jeroen Ooms (2017)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

MagickCore::CommandOption getOptionByName(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickListOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid MagickListOptions value: ") + str);
  return (MagickCore::CommandOption) val;
}

// [[Rcpp::export]]
Rcpp::CharacterVector list_options(const char * str){
  Rcpp::CharacterVector out;
  char ** opts = MagickCore::GetCommandOptions(getOptionByName(str));
  while(opts && *opts)
    out.push_back(*opts++);
  return out;
}
