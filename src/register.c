#include <Rinternals.h>
#include <R_ext/Rdynload.h>

void R_init_magick(DllInfo* info) {
  R_registerRoutines(info, NULL, NULL, NULL, NULL);
  R_useDynamicSymbols(info, TRUE);
}
