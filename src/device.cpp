/* ImageMagick Graphics Device
 * R graphics docs: https://svn.r-project.org/R/trunk/src/include/R_ext/GraphicsDevice.h
 * Magick++ docs: https://www.imagemagick.org/Magick++/Drawable.html
 *
 * Constants are defined in https://svn.r-project.org/R/trunk/src/include/R_ext/GraphicsEngine.h
 * and https://www.imagemagick.org/Magick++/Enumerations.html
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

/* from svglite */
inline bool is_bold(int face) {
  return face == 2 || face == 4;
}
inline bool is_italic(int face) {
  return face == 3 || face == 4;
}
inline bool is_bolditalic(int face) {
  return face == 4;
}
inline bool is_symbol(int face) {
  return face == 5;
}

/* magick style linetype spec */
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

inline Magick::StyleType style(int face){
  return is_italic(face) ? Magick::ItalicStyle : Magick::NormalStyle;
}

inline int weight(int face){
  return is_bold(face) ? 600 : 400;
}

inline std::list<Magick::Coordinate> coord(int n, double * x, double * y){
  std::list<Magick::Coordinate> coordinates;
  for(int i = 0; i < n; i++)
    coordinates.push_back(Magick::Coordinate(x[i], y[i]));
  return coordinates;
}

/* main drawing function */
void image_draw(std::list<Magick::Drawable> x, const pGEcontext gc, pDevDesc dd){
  double lty[8] = {0};
  Frame * graph = getgraph(dd);
  std::list<Magick::Drawable> draw;
  if(gc->col != NA_INTEGER)
    draw.push_back(Magick::DrawableStrokeColor(Color(col2name(gc->col))));
  if(gc->fill != NA_INTEGER)
    draw.push_back(Magick::DrawableFillColor(Color(col2name(gc->fill))));
  draw.push_back(Magick::DrawableStrokeWidth(gc->lwd));
  draw.push_back(Magick::DrawableDashArray(linetype(lty, gc->lty, gc->lwd)));
  draw.push_back(Magick::DrawableStrokeLineCap(linecap(gc->lend)));
  draw.push_back(Magick::DrawableStrokeLineJoin(linejoin(gc->ljoin)));
  draw.push_back(Magick::DrawableMiterLimit(gc->lmitre));
  draw.push_back(Magick::DrawableFont(gc->fontfamily, style(gc->fontface), weight(gc->fontface), Magick::NormalStretch));
  draw.push_back(Magick::DrawablePointSize(gc->ps * gc->cex));
  draw.splice(draw.end(), x);
  graph->gamma(gc->gamma);
  graph->draw(draw);
}

void image_draw(Magick::Drawable x, const pGEcontext gc, pDevDesc dd){
  std::list<Magick::Drawable> draw;
  draw.push_back(x);
  image_draw(draw, gc, dd);
}

/* ~~~ CALLBACK FUNCTIONS START HERE ~~~ */

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
  return;
  BEGIN_RCPP
  Frame mask(Geom(dd->right, dd->bottom), Color("transparent"));
  mask.fillColor("transparent");
  mask.draw( Magick::DrawableRectangle(left, top, right, bottom));
  getgraph(dd)->clipMask(mask);
  VOID_END_RCPP
}

void image_line(double x1, double y1, double x2, double y2, const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  Rprintf("drawling %s line from (%f, %f) to (%f, %f)\n", col2name(gc->col), x1, y1, x2, y2);
  image_draw(Magick::DrawableLine(x1, y1, x2, y2), gc, dd);
  VOID_END_RCPP
}

void image_polyline(int n, double *x, double *y, const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  std::list<Magick::Drawable> draw;
  //Note 'fill' must be unset to prevent magick from creating a polygon
  draw.push_back(Magick::DrawableFillColor(Magick::Color()));
  draw.push_back(Magick::DrawablePolyline(coord(n, x, y)));
  image_draw(draw, gc, dd);
  VOID_END_RCPP
}

void image_polygon(int n, double *x, double *y, const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  image_draw(Magick::DrawablePolygon(coord(n, x, y)), gc, dd);
  VOID_END_RCPP
}

void image_rect(double x0, double y0, double x1, double y1,
                const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  image_draw(Magick::DrawableRectangle(x0, y1, x1, y0), gc, dd);
  VOID_END_RCPP
}

void image_circle(double x, double y, double r, const pGEcontext gc,
                  pDevDesc dd) {
  BEGIN_RCPP
  //note: parameter 3 + 4 must denote any point on the circle
  image_draw(Magick::DrawableCircle(x, y, x, y + r), gc, dd);
  VOID_END_RCPP
}

void image_path(double *x, double *y, int npoly, int *nper, Rboolean winding,
              const pGEcontext gc, pDevDesc dd) {
  BEGIN_RCPP
  getgraph(dd)->fillRule(winding ? Magick::NonZeroRule : Magick::EvenOddRule);
  std::list<Magick::VPath> path;
  for (int i = 0; i < npoly; i++) {
    int n = nper[i];
    path.push_back(Magick::PathMovetoAbs(Magick::Coordinate(x[0], y[0])));
    for(int j = 1; j < n; j++){
      path.push_back(Magick::PathLinetoAbs(Magick::Coordinate(x[j], y[j])));
    }
    path.push_back(Magick::PathLinetoAbs(Magick::Coordinate(x[0], y[0])));
    x+=n;
    y+=n;
  }
  image_draw(Magick::DrawablePath(path), gc, dd);
  VOID_END_RCPP
}

void image_text(double x, double y, const char *str, double rot,
                double hadj, const pGEcontext gc, pDevDesc dd) {
  Rprintf("adding text: '%s' with color '%s' at (%f,%f)'\n", str, col2name(gc->col), x, y);
  BEGIN_RCPP
  Frame * graph = getgraph(dd);
  graph->annotate(str, Geom(0, 0, x, y), Magick::ForgetGravity, -1 * rot);
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

  VOID_END_RCPP
}

/* TODO: need to unprotect the XPTR here */
void image_close(pDevDesc dd) {
  //R_ReleaseObject(getimage(dd))
}

void image_metric_info(int c, const pGEcontext gc, double* ascent,
                       double* descent, double* width, pDevDesc dd) {
  /* DOCS: http://www.imagemagick.org/Magick++/TypeMetric.html */
  bool is_unicode = mbcslocale;
  if (c < 0) {
    is_unicode = true;
    c = -c;
  }

  // Convert to string - negative implies unicode code point
  char str[16];
  if (is_unicode) {
    Rf_ucstoutf8(str, (unsigned int) c);
  } else {
    str[0] = (char) c;
    str[1] = '\0';
  }

  Frame * graph = getgraph(dd);
  graph->fontPointsize(gc->ps * gc->cex);
#if MagickLibVersion >= 0x692
  graph->fontFamily(gc->fontfamily);
  graph->fontWeight(weight(gc->fontface));
  graph->fontStyle(style(gc->fontface));
#else
  graph->font(gc->fontfamily);
#endif
  Magick::TypeMetric tm;
  graph->fontTypeMetrics(str, &tm);
  *ascent = tm.ascent();
  *descent = tm.descent();
  *width = tm.textWidth();
}

double image_strwidth(const char *str, const pGEcontext gc, pDevDesc dd) {
  Frame * graph = getgraph(dd);
#if MagickLibVersion >= 0x692
  graph->fontFamily(gc->fontfamily);
  graph->fontWeight(weight(gc->fontface));
  graph->fontStyle(style(gc->fontface));
#else
  graph->font(gc->fontfamily);
#endif
  graph->fontPointsize(gc->ps * gc->cex);
  Magick::TypeMetric tm;
  graph->fontTypeMetrics(str, &tm);
  return tm.textWidth();
}

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
  dd->path = image_path;
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
