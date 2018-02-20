/* Jeroen Ooms (2017)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

#define Option(type, val) MagickCore::CommandOptionToMnemonic(type, val);

//Workaround for GCC-7:
// - https://github.com/ImageMagick/ImageMagick/issues/707
// - https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=871300
std::string col_to_str(Magick::Color col){
  char output[10] = "#";
  Magick::Quantum red(col.myRedQ());
  Magick::Quantum green(col.myGreenQ());
  Magick::Quantum blue(col.myBlueQ());
  Magick::Quantum alpha(col.myAlphaQ());
  snprintf(&output[1], 3, "%02x", (unsigned char) red);
  snprintf(&output[3], 3, "%02x", (unsigned char) green);
  snprintf(&output[5], 3, "%02x", (unsigned char) blue);
#if MagickLibVersion >= 0x700
  snprintf(&output[7], 3, "%02x", (unsigned char) alpha);
#else //NOTE: alpha scale is reverse on IM6
  snprintf(&output[7], 3, "%02x", 255 - (unsigned char) alpha);
#endif
  return std::string(output);
}

// [[Rcpp::export]]
Rcpp::CharacterVector magick_attr_comment( XPtrImage input, Rcpp::CharacterVector set){
  if(set.size())
    for_each ( input->begin(), input->end(), Magick::commentImage(std::string(set.at(0))));
  Rcpp::CharacterVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->comment());
  return out;
}

// [[Rcpp::export]]
Rcpp::LogicalVector magick_attr_text_antialias( XPtrImage input, Rcpp::LogicalVector set){
  if(set.size())
    for_each ( input->begin(), input->end(), Magick::myAntiAliasImage(set[0]));
  Rcpp::LogicalVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->myAntiAlias());
  return out;
}

// [[Rcpp::export]]
Rcpp::LogicalVector magick_attr_stroke_antialias( XPtrImage input, Rcpp::LogicalVector set){
  Rcpp::LogicalVector out;
  for (Iter it = input->begin(); it != input->end(); ++it){
    if(set.size())
      it->strokeAntiAlias(set[0]);
    out.push_back(it->strokeAntiAlias());
  }
  return out;
}

// [[Rcpp::export]]
Rcpp::IntegerVector magick_attr_animationdelay( XPtrImage input, Rcpp::IntegerVector delay){
  if(delay.size())
    for_each ( input->begin(), input->end(), Magick::animationDelayImage(delay[0]));
  Rcpp::IntegerVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->animationDelay());
  return out;
}

// [[Rcpp::export]]
Rcpp::CharacterVector magick_attr_backgroundcolor( XPtrImage input, Rcpp::CharacterVector color){
  if(color.size())
    for_each ( input->begin(), input->end(), Magick::backgroundColorImage(Color(color[0])));
  Rcpp::CharacterVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(col_to_str(it->backgroundColor()));
  return out;
}

// [[Rcpp::export]]
Rcpp::CharacterVector magick_attr_boxcolor( XPtrImage input, Rcpp::CharacterVector color){
  if(color.size())
    for_each ( input->begin(), input->end(), Magick::boxColorImage(Color(color[0])));
  Rcpp::CharacterVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(col_to_str(it->boxColor()));
  return out;
}

// [[Rcpp::export]]
Rcpp::CharacterVector magick_attr_fillcolor( XPtrImage input, Rcpp::CharacterVector color){
  if(color.size())
    for_each ( input->begin(), input->end(), Magick::fillColorImage(Color(color[0])));
  Rcpp::CharacterVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(col_to_str(it->fillColor()));
  return out;
}

// [[Rcpp::export]]
Rcpp::CharacterVector magick_attr_font( XPtrImage input, Rcpp::CharacterVector font){
  if(font.size())
    for_each ( input->begin(), input->end(), Magick::fontImage(std::string(font[0])));
  Rcpp::CharacterVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->font());
  return out;
}

// [[Rcpp::export]]
Rcpp::IntegerVector magick_attr_fontsize( XPtrImage input, Rcpp::IntegerVector pointsize){
  if(pointsize.size())
    for_each ( input->begin(), input->end(), Magick::fontPointsizeImage(pointsize[0]));
  Rcpp::IntegerVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->fontPointsize());
  return out;
}

// [[Rcpp::export]]
Rcpp::CharacterVector magick_attr_label( XPtrImage input, Rcpp::CharacterVector label){
  if(label.size())
    for_each ( input->begin(), input->end(), Magick::labelImage(std::string(label[0])));
  Rcpp::CharacterVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->label());
  return out;
}

// [[Rcpp::export]]
Rcpp::CharacterVector magick_attr_format( XPtrImage input, Rcpp::CharacterVector format){
  if(format.size())
    for_each ( input->begin(), input->end(), Magick::magickImage(std::string(format[0])));
  Rcpp::CharacterVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->magick());
  return out;
}

// [[Rcpp::export]]
Rcpp::IntegerVector magick_attr_quality( XPtrImage input, Rcpp::IntegerVector quality){
  if(quality.size()){
    if(quality[0] < 0 || quality[0] > 100)
      throw std::runtime_error("quality must be value between 0 and 100");
    for_each ( input->begin(), input->end(), Magick::qualityImage(quality[0]));
  }
  Rcpp::IntegerVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->quality());
  return out;
}

// [[Rcpp::export]]
Rcpp::IntegerVector magick_attr_quantize( XPtrImage input, Rcpp::IntegerVector numcolors){
  if(numcolors.size())
    for_each ( input->begin(), input->end(), Magick::quantizeColorsImage(numcolors[0]));
  Rcpp::IntegerVector out;
  for (Iter it = input->begin(); it != input->end(); ++it)
    out.push_back(it->quantizeColors());
  return out;
}

// [[Rcpp::export]]
Rcpp::DataFrame magick_image_info( XPtrImage input){
  int len = input->size();
  Rcpp::CharacterVector format(len);
  Rcpp::CharacterVector colorspace(len);
  Rcpp::IntegerVector width(len);
  Rcpp::IntegerVector height(len);
  Rcpp::LogicalVector matte(len);
  Rcpp::IntegerVector filesize(len);
  Rcpp::CharacterVector density(len);
  for(int i = 0; i < len; i++){
    Frame frame = input->at(i);
    colorspace[i] = Option(MagickCore::MagickColorspaceOptions, frame.colorSpace());
    Magick::Geometry geom(frame.size());
    format[i] = std::string(frame.magick());
    width[i] = geom.width();
    height[i] = geom.height();
    matte[i] = frame.hasMatte();
    filesize[i] = frame.fileSize();
    density[i] = std::string(frame.density());
  }
  return Rcpp::DataFrame::create(
    Rcpp::_["format"] = format,
    Rcpp::_["width"] = width,
    Rcpp::_["height"] = height,
    Rcpp::_["colorspace"] = colorspace,
    Rcpp::_["matte"] = matte,
    Rcpp::_["filesize"] = filesize,
    Rcpp::_["density"] = density,
    Rcpp::_["stringsAsFactors"] = false
  );
}

// [[Rcpp::export]]
Rcpp::CharacterVector magick_image_as_raster( Rcpp::RawVector data ){
  Rcpp::IntegerVector dim = data.attr("dim") ;
  int w = dim[1], h = dim[2] ;
  static std::string sixteen( "0123456789abcdef" ) ;
  Rcpp::String transparent( "transparent" ) ;

  Rcpp::CharacterMatrix out(h,w) ;
  Rbyte* p = data.begin() ;
  std::string buf( "#00000000" ) ;

  for(int i=0; i<h; i++){
    int k = i*w ;
    for(int j=0; j<w; j++, p+= 4, k++){

      if( p[3] ){
        Rbyte red = p[0], green = p[1], blue = p[2], alpha = p[3];

        buf[1] = sixteen[ red >> 4 ] ;
        buf[2] = sixteen[ red & 0x0F ] ;
        buf[3] = sixteen[ green >> 4 ] ;
        buf[4] = sixteen[ green & 0x0F ] ;
        buf[5] = sixteen[ blue >> 4 ] ;
        buf[6] = sixteen[ blue & 0x0F ] ;
        buf[7] = sixteen[ alpha >> 4 ] ;
        buf[8] = sixteen[ alpha & 0x0F ] ;

        out[k] = Rf_mkCharLen( buf.c_str(), 9) ;

      } else {
        out[k] = transparent ;
      }
    }
  }

  out.attr("class") = "raster" ;
  return out ;

}
