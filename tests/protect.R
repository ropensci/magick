library(magick)

# Test procected from GC while device is open
image <- magick_device()
rm(list=ls())
gc(); gc()
plot(iris)
dev.off()
# This should free the image
gc();

# Test procected from while image is in scope
image <- magick_device()
plot(iris)
dev.off()
gc();gc()
rm(image)
# This should free the image
gc()
