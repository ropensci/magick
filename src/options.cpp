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

// Copied code from MagickCore ListTypeInfo()
// [[Rcpp::export]]
Rcpp::DataFrame list_font_info(){
  size_t number_fonts=0;
  MagickCore::ExceptionInfo *exception = MagickCore::AcquireExceptionInfo();
  const MagickCore::TypeInfo **type_info = MagickCore::GetTypeInfoList("*",&number_fonts,exception);
  if(type_info == NULL || number_fonts == 0)
    return R_NilValue;
  Rcpp::CharacterVector name(number_fonts);
  Rcpp::CharacterVector family(number_fonts);
  Rcpp::CharacterVector glyphs(number_fonts);
  Rcpp::IntegerVector weight(number_fonts);
  for (int i = 0; i < number_fonts; i++){
    if(type_info[i]->name)
      name[i] = type_info[i]->name;
    if(type_info[i]->family)
      family[i] = type_info[i]->family;
    if(type_info[i]->glyphs)
      glyphs[i] = type_info[i]->glyphs;
    if(type_info[i]->weight)
      weight[i] = type_info[i]->weight;
  }
  MagickCore::RelinquishMagickMemory((void *) type_info);
  return Rcpp::DataFrame::create(
    Rcpp::_["name"] = name,
    Rcpp::_["family"] = family,
    Rcpp::_["weight"] = weight,
    Rcpp::_["glyphs"] = glyphs,
    Rcpp::_["stringsAsFactors"] = false
  );
}

// [[Rcpp::export]]
void dump_option_list(SEXP args){
  /* This is equivalent to calling: convert -list font */
  MagickCore::ExceptionInfo *exception = MagickCore::AcquireExceptionInfo();
  MagickCore::ImageInfo *info = MagickCore::AcquireImageInfo();
  const int argc = Rf_length(args);
  const char *argv[1000];
  for(int i = 0; i < argc; i++)
    argv[i] = CHAR(STRING_ELT(args, i));
  MogrifyImageInfo(info, argc, argv, exception);
  info=DestroyImageInfo(info);
#if MagickLibVersion >= 0x690
  Magick::throwException(exception);
#endif
  exception=DestroyExceptionInfo(exception);
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
#if MagickLibVersion >= 0x694
  Magick::SetRandomSeed(seed);
#endif
}
