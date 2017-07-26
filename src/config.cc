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

/* Delegates are defined in include/ImageMagick-6/magick/magick-baseconfig.h */

// [[Rcpp::export]]
Rcpp::List magick_config_internal(){
  Rcpp::List out = Rcpp::List::create(
    Rcpp::_["version"] = MAGICKCORE_PACKAGE_VERSION
  );

#ifdef MAGICKCORE_BUILD_MODULES
  out["modules"] = true;
#else
  out["modules"] = false;
#endif

#ifdef MAGICKCORE_CAIRO_DELEGATE
  out["cairo"] = true;
#else
  out["cairo"] = false;
#endif

#ifdef MAGICKCORE_FONTCONFIG_DELEGATE
  out["fontconfig"] = true;
#else
  out["fontconfig"] = false;
#endif

#ifdef MAGICKCORE_FREETYPE_DELEGATE
  out["freetype"] = true;
#else
  out["freetype"] = false;
#endif

#ifdef MAGICKCORE_FFTW_DELEGATE
  out["fftw"] = true;
#else
  out["fftw"] = false;
#endif

#ifdef MAGICKCORE_GS_DELEGATE
  out["ghostscript"] = true;
#else
  out["ghostscript"] = false;
#endif

#ifdef MAGICKCORE_JPEG_DELEGATE
  out["jpeg"] = true;
#else
  out["jpeg"] = false;
#endif

#ifdef MAGICKCORE_LCMS_DELEGATE
  out["lcms"] = true;
#else
  out["lcms"] = false;
#endif

#ifdef MAGICKCORE_LIBOPENJP2_DELEGATE
  out["libopenjp2"] = true;
#else
  out["libopenjp2"] = false;
#endif

#ifdef MAGICKCORE_LZMA_DELEGATE
  out["lzma"] = true;
#else
  out["lzma"] = false;
#endif

#ifdef MAGICKCORE_PANGOCAIRO_DELEGATE
  out["pangocairo"] = true;
#else
  out["pangocairo"] = false;
#endif

#ifdef MAGICKCORE_PANGO_DELEGATE
  out["pango"] = true;
#else
  out["pango"] = false;
#endif

#ifdef MAGICKCORE_PNG_DELEGATE
  out["png"] = true;
#else
  out["png"] = false;
#endif

#ifdef MAGICKCORE_RSVG_DELEGATE
  out["rsvg"] = true;
#else
  out["rsvg"] = false;
#endif

#ifdef MAGICKCORE_TIFF_DELEGATE
  out["tiff"] = true;
#else
  out["tiff"] = false;
#endif

#ifdef MAGICKCORE_WEBP_DELEGATE
  out["webp"] = true;
#else
  out["webp"] = false;
#endif

#ifdef MAGICKCORE_WMF_DELEGATE
  out["wmf"] = true;
#else
  out["wmf"] = false;
#endif

#ifdef MAGICKCORE_X11_DELEGATE
  out["x11"] = true;
#else
  out["x11"] = false;
#endif

#ifdef MAGICKCORE_XML_DELEGATE
  out["xml"] = true;
#else
  out["xml"] = false;
#endif

#ifdef ZERO_CONFIGURATION_SUPPORT
  out["zero-configuration"] = true;
#else
  out["zero-configuration"] = false;
#endif

  return out;
}
