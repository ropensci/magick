library(magick)
# Using standard device
frink <- image_read("https://jeroen.github.io/images/frink.png")

png("cairo.png", 800, 600, res = 72)
plot(1, xlim = c(0, 100), ylim = c(0, 200), main = "cairo")
plot(as.raster(frink), add = T)
dev.off()
cairo <- image_read("cairo.png")
unlink("cairo.png")

# Using magick
mgk <- image_graph(800, 600, res = 72)
plot(1, xlim = c(0, 100), ylim = c(0, 200), main = "magick")
plot(as.raster(frink), add = T)
dev.off()
c(cairo, mgk)

# Stretchy example
dev <- image_graph(800, 600, res = 96)
plot(cars)
rasterImage(frink, 20, -20, 25, 130)
dev.off()
dev
