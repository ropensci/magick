/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

/* Morphology was added to Magick++ 6.8.8-7 on Feb 16, 2014
 * https://github.com/ImageMagick/ImageMagick/commit/018006bb3daced97350baecc5d172e6561a873cb
 */

#if MagickLibVersion >= 0x688

Magick::KernelInfoType Kernel(const char * str){
  ssize_t val = MagickCore::ParseCommandOption(
    MagickCore::MagickKernelOptions, Magick::MagickFalse, str);
  if(val < 0)
    throw std::runtime_error(std::string("Invalid KernelType value: ") + str);
  return (Magick::KernelInfoType) val;
}

// [[Rcpp::export]]
XPtrImage magick_image_convolve_kernel( XPtrImage input, std::string kernel, size_t iter,
                                 Rcpp::CharacterVector scaling, Rcpp::CharacterVector bias){
  XPtrImage output = copy(input);
  if(scaling.length()){
    for (Iter it = output->begin(); it != output->end(); ++it)
      it->artifact("convolve:scale", std::string(scaling.at(0)));
  }
  if(bias.length()){
    for (Iter it = output->begin(); it != output->end(); ++it)
      it->artifact("convolve:bias", std::string(bias.at(0)));
  }
  for(size_t i = 0; i < output->size(); i++)
    output->at(i).morphology(Magick::ConvolveMorphology, kernel, iter);
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_convolve_matrix( XPtrImage input, Rcpp::NumericMatrix matrix, size_t iter,
                                 Rcpp::CharacterVector scaling, Rcpp::CharacterVector bias){
  XPtrImage output = copy(input);
  if(scaling.length()){
    for (Iter it = output->begin(); it != output->end(); ++it)
      it->artifact("convolve:scale", std::string(scaling.at(0)));
  }
  if(bias.length()){
    for (Iter it = output->begin(); it != output->end(); ++it)
      it->artifact("convolve:bias", std::string(bias.at(0)));
  }
  for(size_t i = 0; i < output->size(); i++)
    for(size_t j = 0; j < iter; j++)
      output->at(i).convolve(matrix.nrow(), matrix.begin());
  return output;
}

#else
XPtrImage magick_image_convolve_kernel( XPtrImage input, std::string kernel, size_t iter,
                                        Rcpp::CharacterVector scaling, Rcpp::CharacterVector bias){
  throw std::runtime_error("ImageMagick too old. Convolve requires at least version  6.8.8");
}

XPtrImage magick_image_convolve_matrix( XPtrImage input, Rcpp::NumericMatrix matrix, size_t iter,
                                        Rcpp::CharacterVector scaling, Rcpp::CharacterVector bias){
  throw std::runtime_error("ImageMagick too old. Convolve requires at least version  6.8.8");
}
#endif
