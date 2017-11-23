library(magick)
img <- image_read("https://www.r-project.org/logo/Rlogo.png")
bitmap <- img[[1]]
bitmap[4,,] <- as.raw(as.integer(bitmap[4,,]) * 0.4)
img <- image_read(bitmap)
#img <- image_convert(img, type = 'grayscale')

library(grid)
grid.newpage()
grid.text("hello world", gp=gpar(cex=5))
grid.draw(rasterGrob(width=1, height=1, image=img))
