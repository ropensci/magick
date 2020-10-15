/* Jeroen Ooms (2018)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

XPtrImage magick_image_bitmap(void * data, Magick::StorageType type, size_t slices, size_t width, size_t height){
  const char * format;
  switch ( slices ){ //TODO: K is blackchannel, there should be a 'graychannel' instead? (G = Green!)
    case 1 : format = "K"; break;
    case 2 : format = "KA"; break;
    case 3 : format = "RGB"; break;
    case 4 : format = "RGBA"; break;
    default: throw std::runtime_error("Invalid number of channels (must be 4 or less)");
  }
  Frame frame(width, height, format, type , data);
  if(slices == 1) //Workaround for using 'K' above
    frame.channel(Magick::BlackChannel);
  frame.magick("PNG");
  XPtrImage image = create();
  image->push_back(frame);
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_readbitmap_native(Rcpp::IntegerMatrix x){
  Rcpp::IntegerVector dims(x.attr("dim"));
  return magick_image_bitmap(x.begin(), Magick::CharPixel, 4, dims[1], dims[0]);
}

// [[Rcpp::export]]
XPtrImage magick_image_readbitmap_raster1(Rcpp::CharacterMatrix x){
  std::vector<rcolor> y(x.size());
  for(size_t i = 0; i < y.size(); i++)
    y[i] = R_GE_str2col(x[i]);
  Rcpp::IntegerVector dims(x.attr("dim"));
  return magick_image_bitmap(y.data(), Magick::CharPixel, 4, dims[0], dims[1]);
}

// [[Rcpp::export]]
XPtrImage magick_image_readbitmap_raster2(Rcpp::CharacterMatrix x){
  std::vector<rcolor> y(x.size());
  for(size_t i = 0; i < y.size(); i++)
    y[i] = R_GE_str2col(x[i]);
  Rcpp::IntegerVector dims(x.attr("dim"));
  return magick_image_bitmap(y.data(), Magick::CharPixel, 4, dims[1], dims[0]);
}

// [[Rcpp::export]]
XPtrImage magick_image_readbitmap_raw(Rcpp::RawVector x){
  Rcpp::IntegerVector dims(x.attr("dim"));
  return magick_image_bitmap(x.begin(), Magick::CharPixel, dims[0], dims[1], dims[2]);
}

// [[Rcpp::export]]
XPtrImage magick_image_readbitmap_double(Rcpp::NumericVector x){
  Rcpp::IntegerVector dims(x.attr("dim"));
  return magick_image_bitmap(x.begin(), Magick::DoublePixel, dims[0], dims[1], dims[2]);
}

// [[Rcpp::export]]
XPtrImage magick_image_readbin(Rcpp::RawVector x, Rcpp::CharacterVector density, Rcpp::IntegerVector depth,
                               bool strip, Rcpp::CharacterVector defines){
  XPtrImage image = create();
#if MagickLibVersion >= 0x689
  Magick::ReadOptions opts = Magick::ReadOptions();
#if MagickLibVersion >= 0x690
  opts.quiet(1);
#endif
  if(density.size())
    opts.density(std::string(density.at(0)).c_str());
  if(depth.size())
    opts.depth(depth.at(0));
  if(defines.size()){
    Rcpp::CharacterVector names = defines.names();
    for(int i = 0; i < defines.size(); i++)
      MagickCore::SetImageOption(opts.imageInfo(), names.at(i), defines.at(i));
  }
  Magick::readImages(image.get(), Magick::Blob(x.begin(), x.length()), opts);
#else
  Magick::readImages(image.get(), Magick::Blob(x.begin(), x.length()));
#endif
  if(strip)
    for_each (image->begin(), image->end(), Magick::stripImage());
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_readpath(Rcpp::CharacterVector paths, Rcpp::CharacterVector density, Rcpp::IntegerVector depth,
                                bool strip, Rcpp::CharacterVector defines){
  XPtrImage image = create();
#if MagickLibVersion >= 0x689
  Magick::ReadOptions opts = Magick::ReadOptions();
#if MagickLibVersion >= 0x690
  opts.quiet(1);
#endif
  if(density.size())
    opts.density(std::string(density.at(0)).c_str());
  if(depth.size())
    opts.depth(depth.at(0));
  if(defines.size()){
    Rcpp::CharacterVector names = defines.names();
    for(int i = 0; i < defines.size(); i++)
      MagickCore::SetImageOption(opts.imageInfo(), names.at(i), defines.at(i));
  }
  for(int i = 0; i < paths.size(); i++)
    Magick::readImages(image.get(), std::string(paths[i]), opts);
#else
  for(int i = 0; i < paths.size(); i++)
    Magick::readImages(image.get(), std::string(paths[i]));
#endif
  if(strip)
    for_each (image->begin(), image->end(), Magick::stripImage());
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_read_list(Rcpp::List list){
  XPtrImage image = create();
  for(int i = 0; i < list.size(); i++) {
    if(TYPEOF(list[i]) != RAWSXP)
      throw std::runtime_error("magick_image_read_list can only read raw vectors");
    Rcpp::RawVector x = list[i];
    Magick::readImages(image.get(), Magick::Blob(x.begin(), x.length()));
  }
  return image;
}

// [[Rcpp::export]]
Rcpp::RawVector magick_image_write( XPtrImage input, Rcpp::CharacterVector format, Rcpp::IntegerVector quality,
                                    Rcpp::IntegerVector depth, Rcpp::CharacterVector density, Rcpp::CharacterVector comment){
  if(!input->size())
    return Rcpp::RawVector(0);
  XPtrImage image = copy(input);
#if MagickLibVersion >= 0x691
  //suppress write warnings see #74 and #116
  image->front().quiet(true);
#endif
  if(format.size())
    for_each ( image->begin(), image->end(), Magick::magickImage(std::string(format[0])));
  if(quality.size())
    for_each ( image->begin(), image->end(), Magick::qualityImage(quality[0]));
  if(depth.size())
    for_each ( image->begin(), image->end(), Magick::depthImage(depth[0]));
  if(density.size()){
    for_each ( image->begin(), image->end(), Magick::resolutionUnitsImage(Magick::PixelsPerInchResolution));
    for_each ( image->begin(), image->end(), Magick::densityImage(Point(density[0])));
  }
  if(comment.size())
    for_each ( image->begin(), image->end(), Magick::commentImage(std::string(comment.at(0))));
  Magick::Blob output;
  writeImages( image->begin(), image->end(),  &output );
  Rcpp::RawVector res(output.length());
  std::memcpy(res.begin(), output.data(), output.length());
  return res;
}

// [[Rcpp::export]]
Rcpp::RawVector magick_image_write_frame(XPtrImage input, const char * format, size_t i = 1){
  if(input->size() < 1)
    throw std::runtime_error("Image must have at least 1 frame to write a bitmap");
  Frame frame = input->at(i-1); //zero indexing!
  Magick::Geometry size(frame.size());
  size_t width = size.width();
  size_t height = size.height();
  Magick::Blob output;
  frame.write(&output, format, 8L);
  if(output.length() == 0)
    throw std::runtime_error("Unsupported raw format: " + std::string(format));
  if(output.length() % (width * height))
    throw std::runtime_error("Dimensions do not add up, '" + std::string(format) + "' may not be a raw format");
  size_t slices = output.length() / (width * height);
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  res.attr("class") = Rcpp::CharacterVector::create("bitmap", format);
  res.attr("dim") = Rcpp::NumericVector::create(slices, width, height);
  return res;
}

// [[Rcpp::export]]
Rcpp::IntegerVector magick_image_write_integer(XPtrImage input){
  if(input->size() != 1)
    throw std::runtime_error("Image must have single frame to write a native raster");
  Frame frame = input->front();
  Magick::Geometry size(frame.size());
  size_t width = size.width();
  size_t height = size.height();
  Magick::Blob output;
  frame.write(&output, "RGBA", 8L);
  Rcpp::IntegerVector res(output.length() / 4);
  memcpy(res.begin(), output.data(), output.length());
  res.attr("class") = Rcpp::CharacterVector::create("nativeRaster");
  res.attr("dim") = Rcpp::NumericVector::create(height, width);
  return res;
}

// [[Rcpp::export]]
XPtrImage magick_image_display( XPtrImage image, bool animate){
#ifndef MAGICKCORE_X11_DELEGATE
  throw std::runtime_error("ImageMagick was built without X11 support");
#else
  XPtrImage output = copy(image);
  if(animate){
    Magick::animateImages(output->begin(), output->end());
  } else {
    Magick::displayImages(output->begin(), output->end());
  }
#endif
  return image;
}

/* Not very useful. Requires imagemagick configuration with --enable-fftw=yes */
// [[Rcpp::export]]
XPtrImage magick_image_fft( XPtrImage image){
  XPtrImage out = create();
  if(image->size())
    forwardFourierTransformImage(out.get(), image->front());
  return out;
}

// [[Rcpp::export]]
XPtrImage magick_image_montage( XPtrImage image, Rcpp::CharacterVector geometry, Rcpp::CharacterVector tile,
                                Rcpp::CharacterVector gravity, std::string bg = "white", bool shadow = false){
  XPtrImage out = create();
  Magick::Montage opts = Magick::Montage();
  if(geometry.length())
    opts.geometry(Geom(geometry.at(0)));
  if(tile.length())
    opts.tile(Geom(tile.at(0)));
  if(gravity.length())
    opts.gravity(Gravity(gravity.at(0)));
  opts.shadow(shadow);
  opts.backgroundColor(bg);
  montageImages(out.get(), image->begin(), image->end(), opts);
  return out;
}

// [[Rcpp::export]]
XPtrImage magick_image_strip( XPtrImage input){
  XPtrImage output = copy(input);
  for_each (output->begin(), output->end(), Magick::stripImage());
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_separate( XPtrImage input, const char * channel){
  XPtrImage output = create();
#if MagickLibVersion >= 0x687
  separateImages( output.get(), input->front(), Channel(channel));
#else
  throw std::runtime_error("Your imagemagick is too old for separateImages");
#endif
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_combine( XPtrImage input, const char * colorspace, const char * channel){
  Frame x;
#if MagickLibVersion >= 0x700
  combineImages(&x, input->begin(), input->end(), Channel(channel), ColorSpace(colorspace));
#elif MagickLibVersion >= 0x687
  combineImages(&x, input->begin(), input->end(), Channel(channel));
  x.colorspaceType(ColorSpace(colorspace));
#else
  throw std::runtime_error("Your imagemagick is too old for combineImages");
#endif
  XPtrImage output = create(1);
  output->push_back(x);
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_set_define( XPtrImage input, Rcpp::CharacterVector format,
                                   Rcpp::CharacterVector name, Rcpp::CharacterVector value){
  //NB: do NOT copy; modifies
  if(!format.length() || !name.length() || !value.length())
    throw std::runtime_error("Missing format or key");
  std::string val(value.at(0));
  std::string fmt(format.at(0));
  std::string key(name.at(0));
  for(size_t i = 0; i < input->size(); i++){
    if(!val.length()){
      input->at(i).defineSet(fmt, key, true); // empty string
    } else if(Rcpp::CharacterVector::is_na(value.at(0))) {
      input->at(i).defineSet(fmt, key, false); // unset
    } else {
      input->at(i).defineValue(fmt, key, val);
    }
  }
  return input;
}
