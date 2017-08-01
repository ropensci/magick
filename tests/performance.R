# Compare performance - with and without clipping

library(ggplot2)

png(tempfile(), width = 600, height = 600)
system.time({print(qplot(mpg, wt, data = mtcars, colour = cyl)); dev.off()})

dev <- magick::image_graph(600, 600, clip = FALSE)
system.time({print(qplot(mpg, wt, data = mtcars, colour = cyl)); dev.off()})

dev <- magick::image_graph(600, 600, clip = TRUE)
system.time({print(qplot(mpg, wt, data = mtcars, colour = cyl)); dev.off()})
print(dev)

