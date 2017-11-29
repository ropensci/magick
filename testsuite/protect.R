library(magick)

# Test procected from GC while device is open
image <- image_graph()
rm(list=ls())
gc(); gc()
plot(rnorm(100))
dev.off()
# This should free the image
gc();

# Test procected from while image is in scope
image <- image_graph()
plot(rnorm(100))
dev.off()
gc();gc()
rm(image)
# This should free the image
gc()
