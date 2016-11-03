#include "magick_types.h"
#include <RcppParallel.h>
using namespace Rcpp ;

inline void fill_rgba( Rbyte* p, Rbyte r, Rbyte g, Rbyte b, Rbyte a){
  p[0] = r ;
  p[1] = g ;
  p[2] = b ;
  p[3] = a ;
}
inline void fill_transparent_white( Rbyte* p){
  fill_rgba(p, 0xff, 0xff, 0xff, 0) ;
}
inline void fill_black( Rbyte* p){
  fill_rgba(p, 0, 0, 0, 0xff) ;
}
inline void fill_gray( Rbyte* p, Rbyte g){
  fill_rgba(p, g, g, g, 0xff) ;
}
inline void fill_channel( Rbyte* p, int channel, Rbyte value){
  p[0] = 0 ;
  p[1] = 0 ;
  p[2] = 0 ;
  p[channel] = value ;
  p[3] = 0xff ;
}


void fill_channel_histogram( Rbyte* data, const IntegerVector& counts, int height, int channel){
  IntegerVector heights = no_init(256) ;
  int max_height = max(counts) ;
  for( int j=0; j<256; j++){
    heights[j] = height - ::floor( (double)counts[j] / max_height * height ) - 1 ;
  }

  Rbyte* p = data ;
  for( int i=0; i<height; i++){
    for( int j=0; j<256; j++){
      int h = heights[j] ;
      if( i > h){
        fill_channel(p, channel, j) ;
      } else if( i == h){
        fill_black(p) ;
      } else {
        fill_transparent_white(p) ;
      }
      p += 4 ;
    }
  }
}

void fill_grayscale_histogram( Rbyte* data, const IntegerVector& red, const IntegerVector& green, const IntegerVector& blue, int height ){
  IntegerVector gray = red + green + blue ;
  int max_gray = max(gray) ;

  IntegerVector heights = no_init(256) ;
  for( int j=0; j<256; j++){
    heights[j] = height - ::floor( (double)gray[j] / max_gray * height ) - 1;
  }

  Rbyte* p = data ;
  for( int i=0; i<height; i++){
    for( int j=0; j<256; j++){
      int h =  heights[j] ;
      if( i > h){
        fill_gray(p, j) ;
      } else if( i == h){
        fill_black(p) ;
      } else {
        fill_transparent_white(p) ;
        p[0] = 0xff ;
        p[1] = 0xff ;
        p[2] = 0xff ;
        p[3] = 0 ;
      }

      p += 4 ;
    }
  }


}


// [[Rcpp::export]]
XPtrImage magick_image_histogram( XPtrImage image , int h ){
  using namespace Magick ;

  Frame frame = image->front() ;
  Blob output;
  frame.write(&output, "rgba", 8L);
  Geometry geom(frame.size());
  int width = geom.width(), height = geom.height() ;

  IntegerVector red(256), green(256), blue(256) ;

  const Rbyte* p = reinterpret_cast<const Rbyte*>( output.data() ) ;
  for( int i=0; i<height; i++){
    for(int j=0; j<width; j++, p+=4){
      if( p[3] ){ // not counting the transparent pixels
        red[ p[0] ]++ ;
        green[ p[1] ]++ ;
        blue[ p[2] ]++ ;
      }
    }
  }

  RawVector out = no_init( 4 * 256 * (4 * h) ) ;

  int slice = 4 * 256 * h ;
  tbb::parallel_invoke(
    [&]{ fill_grayscale_histogram( out.begin() , red, green, blue  , h ) ; },
    [&]{ fill_channel_histogram( out.begin() + slice      , red   , h  , 0 ) ; },
    [&]{ fill_channel_histogram( out.begin() + 2 * slice  , green , h  , 1 ) ; },
    [&]{ fill_channel_histogram( out.begin() + 3 * slice  , blue  , h  , 2 ) ; }
  ) ;

  return magick_image_bitmap(out.begin(), Magick::CharPixel, 4, 256, 4*h);
}
