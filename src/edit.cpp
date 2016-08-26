/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

XPtrImage magick_image_bitmap(void * data, Magick::StorageType type, size_t slices, size_t width, size_t height){
  const char * format;
  switch ( slices ){
    case 1 : format = "G"; break;
    case 2 : format = "GA"; break;
    case 3 : format = "RGB"; break;
    case 4 : format = "RGBA"; break;
    default: throw std::runtime_error("Invalid number of channels (must be 4 or less)");
  }
  Frame frame(width, height, format, type , data);
  frame.magick("png");
  XPtrImage image = create();
  image->push_back(frame);
  return image;
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
XPtrImage magick_image_readbin(Rcpp::RawVector x, Rcpp::CharacterVector density, Rcpp::IntegerVector depth){
  XPtrImage image = create();
#if MagickLibVersion >= 0x689
  Magick::ReadOptions opts = Magick::ReadOptions();
  if(density.size())
    opts.density(std::string(density.at(0)).c_str());
  if(depth.size())
    opts.depth(depth.at(0));
  Magick::readImages(image.get(), Magick::Blob(x.begin(), x.length()), opts);
#else
  Magick::readImages(image.get(), Magick::Blob(x.begin(), x.length()));
#endif
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_readpath(Rcpp::CharacterVector paths, Rcpp::CharacterVector density, Rcpp::IntegerVector depth){
  XPtrImage image = create();
#if MagickLibVersion >= 0x689
  Magick::ReadOptions opts = Magick::ReadOptions();
  if(density.size())
    opts.density(std::string(density.at(0)).c_str());
  if(depth.size())
    opts.depth(depth.at(0));
  for(int i = 0; i < paths.size(); i++)
    Magick::readImages(image.get(), std::string(paths[i]), opts);
#else
  for(int i = 0; i < paths.size(); i++)
    Magick::readImages(image.get(), std::string(paths[i]));
#endif
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
Rcpp::RawVector magick_image_write( XPtrImage input, Rcpp::CharacterVector format, Rcpp::IntegerVector quality){
  if(!input->size())
    return Rcpp::RawVector(0);
  XPtrImage image = copy(input);
  if(format.size())
    for_each ( image->begin(), image->end(), Magick::magickImage(std::string(format[0])));
  if(quality.size())
    for_each ( image->begin(), image->end(), Magick::qualityImage(quality[0]));
  Magick::Blob output;
  writeImages( image->begin(), image->end(),  &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}

// [[Rcpp::export]]
Rcpp::RawVector magick_image_write_frame(XPtrImage input, const char * format){
  if(input->size() < 1)
    throw std::runtime_error("Image must have at least 1 frame to write a bitmap");
  XPtrImage image = copy(input);
  Magick::Blob output;
  input->front().write(&output, format, 8L);
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
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

// [[Rcpp::export]]
XPtrImage magick_image_append( XPtrImage image, bool stack){
  Frame frame;
  appendImages( &frame, image->begin(), image->end(), stack);
  Image *out = new Image;
  out->push_back(frame);
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_average( XPtrImage image){
  Frame frame;
  averageImages( &frame, image->begin(), image->end());
  XPtrImage out = create();
  out->push_back(frame);
  return out;
}

// [[Rcpp::export]]
XPtrImage magick_image_coalesce( XPtrImage image){
  XPtrImage out = create();
  coalesceImages( out.get(), image->begin(), image->end());
  return out;
}

// [[Rcpp::export]]
XPtrImage magick_image_flatten( XPtrImage input, Rcpp::CharacterVector composite){
  Frame frame;
  XPtrImage image = copy(input);
  if(composite.size()){
    for_each ( image->begin(), image->end(), Magick::commentImage("")); //required to force copy; weird bug in IM?
    for_each ( image->begin(), image->end(), Magick::composeImage(Composite(std::string(composite[0]).c_str())));
  }
  flattenImages( &frame, image->begin(), image->end());
  XPtrImage out = create();
  out->push_back(frame);
  return out;
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
XPtrImage magick_image_map( XPtrImage input, XPtrImage map_image, bool dither){
  XPtrImage output = copy(input);
  if(map_image->size())
    mapImages(output->begin(), output->end(), map_image->front(), dither);
  return output;
}

// [[Rcpp::export]]
XPtrImage magick_image_montage( XPtrImage image){
  XPtrImage out = create();
  Magick::Montage montageOpts = Magick::Montage();
  montageImages(out.get(), image->begin(), image->end(), montageOpts);
  return out;
}

// [[Rcpp::export]]
XPtrImage magick_image_morph( XPtrImage image, int frames){
  XPtrImage out = create();
  morphImages( out.get(), image->begin(), image->end(), frames);
  return out;
}

// [[Rcpp::export]]
XPtrImage magick_image_mosaic( XPtrImage input, Rcpp::CharacterVector composite){
  XPtrImage image = copy(input);
  if(composite.size()){
    for_each ( image->begin(), image->end(), Magick::commentImage("")); //required to force copy; weird bug in IM?
    for_each ( image->begin(), image->end(), Magick::composeImage(Composite(std::string(composite[0]).c_str())));
  }
  Frame frame;
  mosaicImages( &frame, image->begin(), image->end());
  XPtrImage out = create();
  out->push_back(frame);
  return out;
}

// [[Rcpp::export]]
XPtrImage magick_image_animate( XPtrImage input, size_t delay, size_t iter, const char * method){
  XPtrImage output = copy(input);
  for_each ( output->begin(), output->end(), Magick::animationDelayImage(delay));
  for_each ( output->begin(), output->end(), Magick::animationIterationsImage(iter));
  for_each ( output->begin(), output->end(), Magick::gifDisposeMethodImage(Dispose(method)));
  for_each ( output->begin(), output->end(), Magick::magickImage("gif"));
  return output;
}
