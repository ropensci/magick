library(magick)
# Using standard device
frink <- image_read("https://jeroen.github.io/images/frink.png")
plot(1, xlim = c(0, 100), ylim = c(0, 200))
plot(as.raster(frink), add = T)

# Using magick
dev <- image_device(800, 600)
plot(1, xlim = c(0, 100), ylim = c(0, 200))
plot(as.raster(frink), add = T)
dev.off()
dev

# Stretchy example
dev <- image_device(800, 600, res = 96)
plot(cars)
rasterImage(frink, 20, -20, 25, 130)
dev.off()
dev
