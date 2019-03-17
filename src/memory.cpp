#include "magick_types.h"

static void* AcquireMemory(size_t n){
  //REprintf("Acquire %d bytes\n", n);
  return R_Calloc(n, char);
}

static void* ResizeMemory(void *ptr, size_t n){
  //REprintf("Resizing to %d bytes\n", n);
  return R_Realloc(ptr, n, char);
}

static void DestroyMemory(void* ptr){
  R_Free(ptr);
}

// [[Rcpp::init]]
void set_memory_pool(DllInfo *dll) {
  //REprintf("Setting memory methods\n");
  MagickCore::SetMagickMemoryMethods(AcquireMemory, ResizeMemory, DestroyMemory);
}
