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
Rcpp::String set_magick_tempdir(const char * new_tmpdir){
  if(new_tmpdir && strlen(new_tmpdir)){
    MagickCore::ExceptionInfo *exception = MagickCore::AcquireExceptionInfo();
    MagickCore::SetImageRegistry(MagickCore::StringRegistryType, "temporary-path", new_tmpdir, exception);
#if MagickLibVersion >= 0x690
    Magick::throwException(exception);
#endif
    exception=DestroyExceptionInfo(exception);
  }
  //Try to read current tempdir
  static char path[MaxTextExtent] = "";
#if MagickLibVersion >= 0x681
  MagickCore::GetPathTemplate(path);
#endif
  return Rcpp::String(path);
}

// [[Rcpp::export]]
void set_magick_seed(unsigned long seed){
  Magick::SetRandomSeed(seed);
}
