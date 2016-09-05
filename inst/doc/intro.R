## ---- echo = FALSE-------------------------------------------------------
library(knitr)
"print.magick-image" <- function(x, ...){
  ext <- ifelse(length(x), tolower(image_info(x[1])$format), "gif")
  tmp <- tempfile(fileext = paste0(".", ext))
  image_write(x, path = tmp)
  knitr::include_graphics(tmp)
}

## ------------------------------------------------------------------------
str(magick::magick_config())

## ------------------------------------------------------------------------
library(magick)
tiger <- image_read('http://jeroenooms.github.io/images/tiger.svg')
image_info(tiger)

## ------------------------------------------------------------------------
tiger_png <- image_convert(tiger, "png")
image_info(tiger_png)

## ------------------------------------------------------------------------
# Example image
frink <- image_read("https://jeroenooms.github.io/images/frink.png")
print(frink)

# Add 20px left/right and 10px top/bottom
image_border(frink, "red", "20x10")

# Trim margins
image_trim(frink)

# Passport pica
image_crop(frink, "100x150+50")

# Resize
image_scale(frink, "300") # width: 300px
image_scale(frink, "x300") # height: 300px

# Rotate or mirror
image_rotate(frink, 45)
image_flip(frink)
image_flop(frink)

# Set a background color
image_background(frink, "pink", flatten = TRUE)
image_fill(frink, "orange", point = "+100+200", fuzz = 30000)

## ------------------------------------------------------------------------
# Add randomness
image_blur(frink, 10, 5)
image_noise(frink)

# This is so ugly it should be illegal
image_frame(frink, "25x25+10+10")

# Silly filters
image_charcoal(frink)
image_oilpaint(frink)
image_edge(frink)
image_negate(frink)

## ------------------------------------------------------------------------
# Add some text
image_annotate(frink, "I like R!", size = 70, gravity = "southwest", color = "green")

# Customize text
image_annotate(frink, "CONFIDENTIAL", size = 30, color = "red", boxcolor = "pink",
  degrees = 60, location = "+50+100")

# Only works if ImageMagick has fontconfig
try(image_annotate(frink, "The quick brown fox", font = 'times-new-roman', size = 30), silent = T)

## ------------------------------------------------------------------------
frink <- image_read("https://jeroenooms.github.io/images/frink.png")
frink2 <- image_scale(frink, "100")
image_info(frink)
image_info(frink2)

## ------------------------------------------------------------------------
test <- image_rotate(frink, 90)
test <- image_background(test, "blue", flatten = TRUE)
test <- image_border(test, "red", "10x10")
test <- image_annotate(test, "This is how we combine transformations", color = "white", size = 30)
print(test)

## ------------------------------------------------------------------------
library(magrittr)
image_read("https://jeroenooms.github.io/images/frink.png") %>%
  image_rotate(270) %>%
  image_background("blue", flatten = TRUE) %>%
  image_border("red", "10x10") %>%
  image_annotate("The same thing with pipes", color = "white", size = 30)

## ------------------------------------------------------------------------
earth <- image_read("https://jeroenooms.github.io/images/earth.gif")
earth <- image_scale(earth, "200")
length(earth)
head(image_info(earth))
print(earth)

rev(earth) %>% 
  image_flip() %>% 
  image_annotate("meanwhile in Australia", size = 20, color = "white")

## ------------------------------------------------------------------------
bigdata <- image_read('https://jeroenooms.github.io/images/bigdata.jpg')
frink <- image_read("https://jeroenooms.github.io/images/frink.png")
logo <- image_read("https://www.r-project.org/logo/Rlogo.png")
img <- c(bigdata, logo, frink)
img <- image_scale(img, "300x300")
image_info(img)

## ------------------------------------------------------------------------
image_mosaic(img)

## ------------------------------------------------------------------------
image_flatten(img)

## ------------------------------------------------------------------------
image_flatten(img, 'Add')
image_flatten(img, 'Modulate')
image_flatten(img, 'Minus')

## ------------------------------------------------------------------------
left_to_right <- image_append(image_scale(img, "x200"))
image_background(left_to_right, "white", flatten = TRUE)

## ------------------------------------------------------------------------
top_to_bottom <- image_append(image_scale(img, "100"), stack = TRUE)
image_background(top_to_bottom, "white", flatten = TRUE)

## ------------------------------------------------------------------------
bigdatafrink <- image_scale(image_rotate(image_background(frink, "none"), 300), "x200")
image_composite(image_scale(bigdata, "x400"), bigdatafrink, offset = "+180+100")

## ---- eval = FALSE-------------------------------------------------------
#  manual <- image_read('https://cran.r-project.org/web/packages/magick/magick.pdf', density = "72x72")
#  image_info(manual)
#  
#  # Convert the first page to PNG
#  image_convert(manual[1], "png", 8)

## ------------------------------------------------------------------------
library(pdftools)
bitmap <- pdf_render_page('https://cran.r-project.org/web/packages/magick/magick.pdf',
  page = 1, dpi = 72, numeric = FALSE)
image_read(bitmap)

## ------------------------------------------------------------------------
image_animate(image_scale(img, "200x200"), fps = 1, dispose = "previous")

## ------------------------------------------------------------------------
newlogo <- image_scale(image_read("https://www.r-project.org/logo/Rlogo.png"), "x150")
oldlogo <- image_scale(image_read("https://developer.r-project.org/Logo/Rlogo-3.png"), "x150")
frames <- image_morph(c(oldlogo, newlogo), frames = 10)
image_animate(frames)

## ------------------------------------------------------------------------
# Foreground image
banana <- image_read("https://jeroenooms.github.io/images/banana.gif")
banana <- image_scale(banana, "150")
image_info(banana)

## ------------------------------------------------------------------------
# Background image
background <- image_background(image_scale(logo, "200"), "white", flatten = TRUE)

# Combine and flatten frames
frames <- lapply(banana, function(frame) {
  image_composite(background, frame, offset = "+70+30")
})

# Turn frames into animation
animation <- image_animate(image_join(frames))
print(animation)

## ------------------------------------------------------------------------
plot(as.raster(frink))

## ---- fig.width=7, fig.height=5------------------------------------------
# Print over another graphic
plot(cars)
rasterImage(frink, 21, 0, 25, 80)

## ---- fig.width=5, fig.height=3------------------------------------------
library(ggplot2)
library(grid)
qplot(speed, dist, data = cars, geom = c("point", "smooth"))
grid.raster(frink)

## ---- fig.height=2-------------------------------------------------------
tiff_file <- tempfile()
image_write(frink, path = tiff_file, format = 'tiff')
r <- raster::brick(tiff_file)
raster::plotRGB(r)

## ---- fig.height=2-------------------------------------------------------
buf <- as.integer(frink[[1]])
rr <- raster::brick(buf)
raster::plotRGB(rr, asp = 1)

