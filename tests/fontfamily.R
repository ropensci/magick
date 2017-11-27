img <- image_graph(height = 400, pointsize = 20, res = 120)


# Initialize plot & print text
par(mar = c(0,0,0,0))
plot(c(0,1.6), axes = FALSE, main = "", xlab = "", ylab = "", col = "white")


# Sans fonts
text(0.95, 0.1, "abcdefg  - Sans (Arial)", pos = 4, family = "Sans Serif")
text(0.95, 0.3, "abcdefg  - Comic Sans", pos = 4, family = "Comic Sans")

#Serif fonts
text(0.95, 0.5, "abcdefg - Serif (Times)", pos = 4, family = "Serif")
text(0.95, 0.7, "abcdefg - Georgia Serif", pos = 4, family = "Georgia")

#Monospace
text(0.95, 0.9, "abcdefg - Monospace (Courier New)", pos = 4, family = "Monospace")
text(0.95, 1.1, "abcdefg - Courier", pos = 4, family = "Courier")

#SYMBOL (both methods)
text(0.95, 1.3, "abcdefg - Symbol Family", pos = 4, family = "Symbol")
text(0.95, 1.5, "ABCDEF - Symbol Face", pos = 4, font = 5)

dev.off()
