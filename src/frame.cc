#include "magick_types.h"
#include <iostream>

//External R pointer finalizer
void finalize_frame( Frame *frame ){
  delete frame;
}

// [[Rcpp::export]]
XPtrFrame magick_frame_read(Rcpp::RawVector x){
  Magick::Blob input( x.begin(), x.length());
  Frame *frame = new Frame( input );
  XPtrFrame ptr(frame);
  ptr.attr("class") = Rcpp::CharacterVector::create("magick-frame");
  return ptr;
}

// [[Rcpp::export]]
Rcpp::RawVector magick_frame_write( XPtrFrame frame, Rcpp::String format){
  Magick::Blob output;
  if(strlen(format.get_cstring()))
    frame->magick( format );
  frame->write( &output );
  Rcpp::RawVector res(output.length());
  memcpy(res.begin(), output.data(), output.length());
  return res;
}

// [[Rcpp::export]]
Rcpp::List magick_frame_info( XPtrFrame frame){
  return Rcpp::List::create(
    Rcpp::_["size"] = Rcpp::String(frame->size()),
    Rcpp::_["density"] = Rcpp::String(frame->density()),
    Rcpp::_["page"] = Rcpp::String(frame->page()),
    Rcpp::_["font"] = Rcpp::String(frame->font()),
    Rcpp::_["quality"] = frame->quality(),
    Rcpp::_["filesize"] = frame->fileSize(),
    Rcpp::_["format"] = frame->format(),
    Rcpp::_["magick"] = frame->magick()
  );
}
