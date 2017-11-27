# Check ?plotmath for symbol math examples

img <- image_graph(width = 600, height = 400, pointsize = 20, res = 100)
#png("families.png", width = 600, height = 400, pointsize = 20, res = 100)


graphics::plot.new()
graphics::par(mar = c(0,0,3,0))
graphics::plot.window(xlim = c(0, 20), ylim = c(-.5, 8), xaxs = "i", yaxs = "i")

title(expression(Gamma %prop% sum(x[alpha], i==1, n) * sqrt(mu)), expression(hat(x)))


# Standard families as supported by other devices
text(0.95, 7, "abcdefg  - Sans (Arial)", pos = 4, family = "sans")
text(0.95, 6, "abcdefg - Serif (Times)", pos = 4, family = "serif")
text(0.95, 5, "abcdefg - Monospace (Courier New)", pos = 4, family = "mono")
text(0.95, 4, "abcdefg - Symbol Face", pos = 4, font = 5)

# Extra fonts implemented in magick
text(0.95, 2, "abcdefg  - Comic Sans", pos = 4, family = "Comic Sans")
text(0.95, 1, "abcdefg - Georgia Serif", pos = 4, family = "Georgia")
text(0.95, 0, "abcdefg - Courier", pos = 4, family = "Courier")


dev.off()
