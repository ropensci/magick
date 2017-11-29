test_rotate <- function(){
  plot(-1:1, -1:1, type = "n", xlab = "Re", ylab = "Im")
  K <- 16; text(exp(1i * 2 * pi * (1:K) / K), col = 2, srt = 30)
}

test_circle <- function(){
  N <- nrow(trees)
  with(trees, {
    ## Girth is diameter in inches
    symbols(Height, Volume, circles = Girth/24, inches = FALSE, bg = "blue",
            main = "Trees' Girth") # xlab and ylab automatically
    ## Colours too:
    op <- palette(rainbow(N, end = 0.9))
    symbols(Height, Volume, circles = Girth/16, inches = FALSE, bg = 1:N,
            fg = "gray30", main = "symbols(*, circles = Girth/16, bg = 1:N)")
    palette(op)
  })
}

test_rect <- function(){
  op <- par(bg = "thistle")
  plot(c(100, 250), c(300, 450), type = "n", xlab = "", ylab = "",
       main = "2 x 11 rectangles; 'rect(100+i,300+i,  150+i,380+i)'")
  i <- 4*(0:10)
  ## draw rectangles with bottom left (100, 300)+i
  ## and top right (150, 380)+i
  rect(100+i, 300+i, 150+i, 380+i, col = rainbow(11, start = 0.7, end = 0.1))
  rect(240-i, 320+i, 250-i, 410+i, col = heat.colors(11), lwd = i/5)
}

test_path <- function(){dev
  plotPath <- function(x, y, col = "grey", rule = "winding") {
    plot.new()
    plot.window(range(x, na.rm = TRUE), range(y, na.rm = TRUE))
    polypath(x, y, col = col, rule = rule)
    if (!is.na(col))
      mtext(paste("Rule:", rule), side = 1, line = 0)
  }

  plotRules <- function(x, y, title) {
    plotPath(x, y)
    plotPath(x, y, rule = "evenodd")
    mtext(title, side = 3, line = 0)
    plotPath(x, y, col = NA)
  }

  op <- par(mfrow = c(5, 3), mar = c(2, 1, 1, 1))

  plotRules(c(.1, .1, .9, .9, NA, .2, .2, .8, .8),
            c(.1, .9, .9, .1, NA, .2, .8, .8, .2),
            "Nested rectangles, both clockwise")
}

test_ggplot <- function(){
  print(ggplot2::qplot(cars$speed, cars$dist, geom = c("point", "smooth")))
}

test_ggplot2 <- function(){
  ggplot(diamonds, aes(cut, price)) +
    geom_boxplot() +
    coord_flip()
}

unlink("*.png")

png("cairo_small.png", width = 800, height = 600)
par(cex = 96/72)
test_ggplot()
dev.off()

png("cairo_large.png", width = 1600, height = 1200, res = 144)
par(cex = 96/72)
test_ggplot()
dev.off()

dev <- magick::image_graph(800, 600, bg = 'white')
test_ggplot()
dev.off()
image_write(dev, "magick_small.png", format = 'png')

dev <- magick::image_graph(1600, 1200, bg = 'white', res = 144)
test_ggplot()
dev.off()
image_write(dev, "magick_large.png", format = 'png')

# Compare in rstudio
img <- image_graph(900, 600, bg = 'white', res = 96)
test_ggplot()
dev.off()
print(img)

# rstudio device
test_ggplot()

#par(cex = 2)
#test_ggplot()
#dev.off()
#print(utils::tail(dev, 1))
