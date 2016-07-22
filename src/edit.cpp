/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"

// [[Rcpp::export]]
XPtrImage magick_image_read(Rcpp::RawVector x){
  XPtrImage image = create();
  Magick::readImages(image.get(), Magick::Blob(x.begin(), x.length()));
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
Rcpp::RawVector magick_image_write( XPtrImage image){
  if(!image->size())
    return Rcpp::RawVector(0);
  Magick::Blob output;
  writeImages( image->begin(), image->end(),  &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}

// [[Rcpp::export]]
XPtrImage magick_image_display( XPtrImage image, bool animate){
#ifndef MAGICKCORE_X11_DELEGATE
  throw std::runtime_error("ImageMagick was build without X11 support");
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
XPtrImage magick_image_flatten( XPtrImage image){
  Frame frame;
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
XPtrImage magick_image_mosaic( XPtrImage image){
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
