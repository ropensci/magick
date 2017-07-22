/* ImageMagick Graphics Device
 * R graphics docs: https://svn.r-project.org/R/trunk/src/include/R_ext/GraphicsDevice.h
 * Magick++ docs: https://www.imagemagick.org/Magick++/Drawable.html
 *
 * TODO: make everything static?
 */
#include "magick_types.h"
#include <R_ext/GraphicsEngine.h>

inline Image * getimage(pDevDesc dd){
  Image *image = (Image*) dd->deviceSpecific;
  if(image == NULL)
    throw std::runtime_error("Graphics device pointing to NULL image");
  return image;
}

inline Frame * getgraph(pDevDesc dd){
  Image * image = getimage(dd);
  if(image->size() < 1)
    throw std::runtime_error("Magick device has zero pages");
  return &image->back();
}

inline Frame getcur(pDevDesc dd){
  Image * image = getimage(dd);
  if(image->size() < 1)
    throw std::runtime_error("Magick device has zero pages");
  return image->back();
}

inline double * linetype(double * lty, int type, int lwd){
  switch(type){
  case LTY_BLANK:
  case LTY_SOLID:
    break;
  case LTY_DASHED:
    lty[0] = 5 * lwd;
    lty[1] = 3 * lwd;
    break;
  case LTY_DOTTED:
    lty[0] = 1 * lwd;
    lty[1] = 2 * lwd;
    break;
  case LTY_DOTDASH:
    lty[0] = 5 * lwd;
    lty[1] = 3 * lwd;
    lty[2] = 2 * lwd;
    lty[3] = 3 * lwd;
    break;
  case LTY_LONGDASH:
    lty[0] = 8 * lwd;
    lty[1] = 3 * lwd;
    break;
  case LTY_TWODASH:
    lty[0] = 5 * lwd;
    lty[1] = 2 * lwd;
    lty[2] = 5 * lwd;
    lty[3] = 5 * lwd;
    break;
  }
  return lty;
}

inline Magick::DrawableStrokeLineCap linecap(R_GE_lineend type){
  switch(type){
  case GE_ROUND_CAP:
    return Magick::RoundCap;
  case GE_BUTT_CAP:
    return Magick::ButtCap;
  case GE_SQUARE_CAP:
    return Magick::SquareCap;
  }
  return Magick::RoundCap;
}

inline Magick::DrawableStrokeLineJoin linejoin(R_GE_linejoin type){
  switch(type){
  case GE_ROUND_JOIN:
    return Magick::RoundJoin;
  case GE_MITRE_JOIN:
    return Magick::MiterJoin;
  case GE_BEVEL_JOIN:
    return Magick::BevelJoin;
  }
  return Magick::RoundJoin;
}

/* TODO: I don't understand what this function does */
void image_metric_info(int c, const pGEcontext gc, double* ascent,
                     double* descent, double* width, pDevDesc dd) {

}

void image_new_page(const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  Image *image = getimage(dd);
  Frame x(Geom(dd->right, dd->bottom), Color(col2name(dd->startfill)));
  x.magick("png"); //TODO: do not do this
  image->push_back(x);
  VOID_END_RCPP
}

/* TODO: test if we got the coordinates right  */
/* TODO: how to unset the clipmask ? */
void image_clip(double left, double right, double bottom, double top, pDevDesc dd) {
  Rprintf("Clipping at (%f, %f) to (%f, %f)\n", left, top, right, bottom);
  BEGIN_RCPP
  Frame mask(Geom(dd->right, dd->bottom), Color("transparent"));
  mask.fillColor("transparent");
  mask.draw( Magick::DrawableRectangle(left, top, right, bottom));
  getgraph(dd)->clipMask(mask);
  VOID_END_RCPP
}

/* TODO: need to unprotect the XPTR here */
void image_close(pDevDesc dd) {
  //R_ReleaseObject(getimage(dd))
}

void image_line(double x1, double y1, double x2, double y2, const pGEcontext gc, pDevDesc dd) {
  Rprintf("drawling %s line from (%f, %f) to (%f, %f)\n", col2name(gc->col), x1, y1, x2, y2);
  BEGIN_RCPP
  //line width and type
  double lty[8] = {0};
  Frame * graph = getgraph(dd);
  std::list<Magick::Drawable> draw;
  draw.push_back(Magick::DrawableStrokeColor(col2name(gc->col)));
  draw.push_back(Magick::DrawableFillColor(col2name(dd->startfill)));
  draw.push_back(Magick::DrawableStrokeWidth(gc->lwd));
  draw.push_back(Magick::DrawableDashArray(linetype(lty, gc->lty, gc->lwd)));
  draw.push_back(Magick::DrawableLine(x1, y1, x2, y2));
  draw.push_back(Magick::DrawableStrokeLineCap(linecap(gc->lend)));
  draw.push_back(Magick::DrawableStrokeLineJoin(linejoin(gc->ljoin)));
  graph->gamma(gc->gamma);
  graph->draw(draw);
  VOID_END_RCPP
}

void image_polyline(int n, double *x, double *y, const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  Frame graphic = getcur(dd);
  std::list<Magick::Coordinate> coordinates;
  for(int i = 0; i < n; i++)
    coordinates.push_back(Magick::Coordinate(x[i], y[i]));
  graphic.draw( Magick::DrawablePolyline(coordinates));
  VOID_END_RCPP
}

void image_polygon(int n, double *x, double *y, const pGEcontext gc,
                 pDevDesc dd) {
  BEGIN_RCPP
  Frame graphic = getcur(dd);
  std::list<Magick::Coordinate> coordinates;
  for(int i = 0; i < n; i++)
    coordinates.push_back(Magick::Coordinate(x[i], y[i]));
  graphic.draw( Magick::DrawablePolygon(coordinates));
  VOID_END_RCPP
}

void image_path(double *x, double *y, int npoly, int *nper, Rboolean winding,
              const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  Frame graphic = getcur(dd);

  VOID_END_RCPP

}

double image_strwidth(const char *str, const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  Frame graphic = getcur(dd);

  VOID_END_RCPP

  return 0;
}

void image_rect(double x0, double y0, double x1, double y1,
              const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  Frame graphic = getcur(dd);
  graphic.draw( Magick::DrawableRectangle(x0, y0, x1, y1) );
  VOID_END_RCPP

}

void image_circle(double x, double y, double r, const pGEcontext gc,
                pDevDesc dd) {
  BEGIN_RCPP
  Frame graphic = getcur(dd);
  //TODO: magick has separate x and y 'perimeter'
  graphic.draw( Magick::DrawableCircle(x, y, r, r) );
  VOID_END_RCPP

}

void image_text(double x, double y, const char *str, double rot,
              double hadj, const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  Frame graphic = getcur(dd);

  VOID_END_RCPP

}

void image_size(double *left, double *right, double *bottom, double *top,
              pDevDesc dd) {
  *left = dd->left;
  *right = dd->right;
  *bottom = dd->bottom;
  *top = dd->top;
}

void image_raster(unsigned int *raster, int w, int h,
                double x, double y,
                double width, double height,
                double rot,
                Rboolean interpolate,
                const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  Frame graphic = getcur(dd);

  VOID_END_RCPP}


pDevDesc magick_driver_new(Image * image, int bg, int width, int height, double pointsize) {

  pDevDesc dd = (DevDesc*) calloc(1, sizeof(DevDesc));
  if (dd == NULL)
    return dd;

  dd->startfill = bg;
  dd->startcol = R_RGB(0, 0, 0);
  dd->startps = pointsize;
  dd->startlty = 0;
  dd->startfont = 1;
  dd->startgamma = 1;

  // Callbacks
  dd->activate = NULL;
  dd->deactivate = NULL;
  dd->close = image_close;
  dd->clip = image_clip;
  dd->size = image_size;
  dd->newPage = image_new_page;
  dd->line = image_line;
  dd->text = image_text;
  dd->strWidth = image_strwidth;
  dd->rect = image_rect;
  dd->circle = image_circle;
  dd->polygon = image_polygon;
  dd->polyline = image_polyline;
  dd->path = NULL; //image_path;
  dd->mode = NULL;
  dd->metricInfo = image_metric_info;
  dd->cap = NULL;
  dd->raster = image_raster;

  // UTF-8 support
  dd->wantSymbolUTF8 = (Rboolean) 1;
  dd->hasTextUTF8 = (Rboolean) 1;
  dd->textUTF8 = image_text;
  dd->strWidthUTF8 = image_strwidth;

  // Screen Dimensions in pts
  dd->left = 0;
  dd->top = 0;
  dd->right = width;
  dd->bottom = height;

  // Magic constants copied from other graphics devices
  // nominal character sizes in pts
  dd->cra[0] = 0.9 * pointsize;
  dd->cra[1] = 1.2 * pointsize;
  // character alignment offsets
  dd->xCharOffset = 0.4900;
  dd->yCharOffset = 0.3333;
  dd->yLineBias = 0.2;
  // inches per pt
  dd->ipr[0] = 1.0 / 72.0;
  dd->ipr[1] = 1.0 / 72.0;

  // Capabilities
  dd->canClip = TRUE;
  dd->canHAdj = 0;
  dd->canChangeGamma = FALSE;
  dd->displayListOn = FALSE;
  dd->haveTransparency = 2;
  dd->haveTransparentBg = 2;

  dd->deviceSpecific = image;
  return dd;
}

/* Adapted from svglite */
void makeDevice(Image * image, std::string bg_, int width, int height, double pointsize) {
  int bg = R_GE_str2col(bg_.c_str());
  R_GE_checkVersionOrDie(R_GE_version);
  R_CheckDeviceAvailable();
  BEGIN_SUSPEND_INTERRUPTS {
    pDevDesc dev = magick_driver_new(image, bg, width, height, pointsize);
    if (dev == NULL)
      throw std::runtime_error("Failed to start Magick device");
    pGEDevDesc dd = GEcreateDevDesc(dev);
    GEaddDevice2(dd, "magick");
    GEinitDisplayList(dd);
  } END_SUSPEND_INTERRUPTS;
}


// [[Rcpp::export]]
XPtrImage magick_(std::string bg, int width, int height, double pointsize) {
  XPtrImage image = create(0);
  R_PreserveObject(image);
  makeDevice(image.get(), bg, width, height, pointsize);
  return image;
}
