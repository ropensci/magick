# Test that cipping area is reset when device gets closed
img <- image_graph(600, 400, res = 96, clip = TRUE)
plot(iris)
dev.off()
image_flip(image_flop(image_flip(image_flop(img))))
