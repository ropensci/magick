library(magick)
frink <- image_read("https://jeroen.github.io/images/frink.png")

# NOTE: default type "quartz" from getOption("bitmapType") generates slightly different colors
png("cairo.png", 800*2, 600*2, pointsize = 32, type = "cairo")
plot(1, xlim = c(0, 100), ylim = c(0, 200), main = "cairo")
plot(as.raster(frink), add = T)
text( 20, 100, "This is a test!", family = 'serif', col = "hotpink", cex = 4)
dev.off()
cairo <- image_read("cairo.png")
unlink("cairo.png")

library(svglite)
svglite::svglite("svglite.svg", width = 1600/72, height = 1200/72, pointsize = 32)
plot(1, xlim = c(0, 100), ylim = c(0, 200), main = "svglite")
plot(as.raster(frink), add = T)
text( 20, 100, "This is a test!", family = 'serif', col = "hotpink", cex = 4)
dev.off()
svglite <- image_read("svglite.svg")
unlink("svglite.svg")
unlink("svglite.png")

# Using magick
mgk <- image_graph(800*2, 600*2, pointsize = 32)
plot(1, xlim = c(0, 100), ylim = c(0, 200), main = "magick")
plot(as.raster(frink), add = T)
text( 20, 100, "This is a test!", family = 'serif', col = "hotpink", cex = 4)
dev.off()

# Compare
all <- c(cairo, svglite, mgk)
image_info(all)
image_browse(image_animate(all))

# Stretchy example
dev <- image_graph(800, 600, res = 96)
plot(cars)
rasterImage(frink, 20, -20, 25, 130)
dev.off()
dev
