frink <- image_read("https://jeroen.github.io/images/frink.png")
image_annotate(frink, "CONFIDENTIAL", size = 30, color = "red", boxcolor = "pink",
               degrees = 60, location = "+50+100")


im1 <- image_graph()
op <- par(bg = "thistle")
plot(c(100, 250), c(300, 450), type = "n", xlab = "", ylab = "")
image <- as.raster(matrix(0:1, ncol = 5, nrow = 3))
rasterImage(image, 100, 300, 150, 350, angle = 30, interpolate = FALSE)
rasterImage(image, 100, 400, 150, 450, angle = 300)
rasterImage(image, 200, 300, 200 + xinch(.5), 300 + yinch(.3), angle = 30, interpolate = FALSE)
rasterImage(image, 200, 400, 250, 450, angle = -200, interpolate = FALSE)
dev.off()

png('cairo.png', width = 800, height = 600)
op <- par(bg = "thistle")
plot(c(100, 250), c(300, 450), type = "n", xlab = "", ylab = "")
image <- as.raster(matrix(0:1, ncol = 5, nrow = 3))
rasterImage(image, 100, 300, 150, 350, angle = 30, interpolate = FALSE)
rasterImage(image, 100, 400, 150, 450, angle = 300)
rasterImage(image, 200, 300, 200 + xinch(.5), 300 + yinch(.3), angle = 30, interpolate = FALSE)
rasterImage(image, 200, 400, 250, 450, angle = -200, interpolate = FALSE)
dev.off()
im2 <- image_read('cairo.png')
unlink('cairo.png')

image_animate(c(im1, im2), fps = 1)