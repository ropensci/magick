test_text <- function(){
  plot(1)
  text(1, 1.0, "Regular Text", font=1, cex = 2)
  text(1, 1.1, "Bold Text", font=2, cex = 3)
  text(1, 1.2, "Italic Text", font=3, cex = 2)
  text(1, 1.3, "Bold Italic", font=4, cex = 2)
  text(1, 0.7, expression(symbol("\047 \044 \047 ")), font=5, cex = 2)
}

png("cairo.png", 800, 600)
test_text()
dev.off()

img <- image_graph(800, 600, bg = 'white')
test_text()
dev.off()
image_write(img, "magick.png")

browseURL('cairo.png')
browseURL('magick.png')
