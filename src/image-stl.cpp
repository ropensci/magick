/* Jeroen Ooms (2016)
 * Bindings to vectorized image manipulations.
 * See API: https://www.imagemagick.org/Magick++/STL.html
 */

#include "magick_types.h"
#include <list>

// [[Rcpp::export]]
XPtrImage magick_image_read(Rcpp::RawVector x){
  Image *image = new Image;
  Magick::readImages(image, Magick::Blob(x.begin(), x.length()));
  XPtrImage ptr(image);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_read_list(Rcpp::List list){
  Image *image = new Image;
  for(int i = 0; i < list.size(); i++) {
    if(TYPEOF(list[i]) != RAWSXP)
      throw std::runtime_error("magick_image_read_list can only read raw vectors");
    Rcpp::RawVector x = list[i];
    Magick::readImages(image, Magick::Blob(x.begin(), x.length()));
  }
  XPtrImage ptr(image);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
Rcpp::RawVector magick_image_write( XPtrImage image){
  Magick::Blob output;
  writeImages( image->begin(), image->end(),  &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
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
  Image *out = new Image;
  out->push_back(frame);
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_coalesce( XPtrImage image){
  Image *out = new Image;
  coalesceImages( out, image->begin(), image->end());
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_flatten( XPtrImage image){
  Frame frame;
  flattenImages( &frame, image->begin(), image->end());
  Image *out = new Image;
  out->push_back(frame);
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

/* Not very useful. Requires imagemagick configuration with --enable-fftw=yes */
// [[Rcpp::export]]
XPtrImage magick_image_fft( XPtrImage image){
  Image *out = new Image;
  Frame frame(image->front()); //only decompose first frame
  forwardFourierTransformImage(out, frame);
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_map( XPtrImage image, XPtrImage map_image, bool dither){
  mapImages(image->begin(), image->end(), map_image->front(), dither);
  return image;
}

// [[Rcpp::export]]
XPtrImage magick_image_montage( XPtrImage image){
  Image *out = new Image;
  Magick::Montage montageOpts = Magick::Montage();
  montageImages(out, image->begin(), image->end(), montageOpts);
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_morph( XPtrImage image, int frames){
  Image *out = new Image;
  morphImages( out, image->begin(), image->end(), frames);
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_mosaic( XPtrImage image){
  Frame frame;
  mosaicImages( &frame, image->begin(), image->end());
  Image *out = new Image;
  out->push_back(frame);
  XPtrImage ptr(out);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-image");
  return ptr;
}

// [[Rcpp::export]]
XPtrImage magick_image_quantize(XPtrImage image){
  quantizeImages(image->begin(), image->end());
  return image;
}
