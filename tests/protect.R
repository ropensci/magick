library(magick)

# Test procected from GC while device is open
image <- image_device()
rm(list=ls())
gc(); gc()
plot(rnorm(100))
dev.off()
# This should free the image
gc();

# Test procected from while image is in scope
image <- image_device()
plot(rnorm(100))
dev.off()
gc();gc()
rm(image)
# This should free the image
gc()
