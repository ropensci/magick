/* Jeroen Ooms (2018)
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

// [[Rcpp::export]]
Rcpp::String set_magick_tempdir(const char * tmpdir){
  MagickCore::ExceptionInfo *exception = MagickCore::AcquireExceptionInfo();
  MagickCore::SetImageRegistry(MagickCore::StringRegistryType, "temporary-path", tmpdir, exception);
  exception=DestroyExceptionInfo(exception);

  char path[4000] = "";
#if MagickLibVersion >= 0x681
  MagickCore::GetPathTemplate(path);
#endif

  /* Remove file template except for the leading "/path/to/magick-" */
  if(strlen(path) < 24)
    return Rcpp::String(NA_STRING);
  path[strlen(path)-17]='\0';
  return Rcpp::String(path);
}
