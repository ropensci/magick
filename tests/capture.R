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

# Scaled doubles
img <- readPNG(system.file("img", "Rlogo.png", package="png"))
img_native <- readPNG(system.file("img", "Rlogo.png", package="png"), native = TRUE)
magick::image_read(buf)
magick::image_read(as.raster(buf))
magick::image_read(img_native)
