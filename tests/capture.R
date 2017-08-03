# Capture native rasters from another device
Cairo::Cairo(type="raster", width = 800, height = 600)
ggplot2::qplot(speed, dist, data = cars, geom = c("smooth", "point"))
img <- magick::image_capture()
dev.off()
print(img)

# Capture from magick device itself
img <- image_graph()
ggplot2::qplot(rnorm(1e5))
xn <- dev.capture(native = TRUE)
dev.off()
image_read(xn)
