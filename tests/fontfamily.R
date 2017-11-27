# Check ?plotmath for symbol math examples

img <- image_graph(height = 400, pointsize = 20, res = 100)

graphics::plot.new()
graphics::par(mar = c(0,1,3,0))
graphics::plot.window(xlim = c(0, 10), ylim = c(0, 8), xaxs = "i", yaxs = "i")

title(expression(Gamma %prop% sum(x[alpha], i==1, n) * sqrt(mu)), expression(hat(x)))



# Sans fonts
text(0.95, 1, "abcdefg  - Sans (Arial)", pos = 4, family = "Sans Serif")
text(0.95, 2, "abcdefg  - Comic Sans", pos = 4, family = "Comic Sans")

#Serif fonts
text(0.95, 3, "abcdefg - Serif (Times)", pos = 4, family = "Serif")
text(0.95, 4, "abcdefg - Georgia Serif", pos = 4, family = "Georgia")

#Monospace
text(0.95, 5, "abcdefg - Monospace (Courier New)", pos = 4, family = "Monospace")
text(0.95, 6, "abcdefg - Courier", pos = 4, family = "Courier")

#SYMBOL (both methods)
text(0.95, 7, "abcdefg - Symbol Face", pos = 4, font = 5)

dev.off()
