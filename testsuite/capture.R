frink <- image_read("https://jeroen.github.io/images/frink.png")


# Capture native rasters from another device
Cairo::Cairo(type="raster", width = 800, height = 600)
ggplot2::qplot(speed, dist, data = cars, geom = c("smooth", "point"))
xc <- dev.capture()
xn <- dev.capture(native = TRUE)
graphics.off()

frink
image_read(xc)

frink
image_read(xn)

raster <- as.raster(image_read(xn))
plot(raster)

frink
plot(frink)
image_read(raster)

# Scaled doubles
img <- png::readPNG(system.file("img", "Rlogo.png", package="png"))
img_native <- png::readPNG(system.file("img", "Rlogo.png", package="png"), native = TRUE)
magick::image_read(img)
magick::image_read(img_native)

