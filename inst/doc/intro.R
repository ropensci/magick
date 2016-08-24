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
tiger <- image_read('https://upload.wikimedia.org/wikipedia/commons/f/fd/Ghostscript_Tiger.svg')
image_info(tiger)

## ------------------------------------------------------------------------
# Render svg to png bitmap
image_write(tiger, path = "tiger.png", format = "png")

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
image_emboss(frink)
image_edge(frink)
image_negate(frink)

## ------------------------------------------------------------------------
# Add some text
image_annotate(frink, "I like R!", size = 70, gravity = "southwest", color = "green")

# Customize text
image_annotate(frink, "CONFIDENTIAL", size = 30, color = "red", boxcolor = "pink",
  degrees = 60, location = "+50+100")

# Only works if ImageMagick has fontconfig
image_annotate(frink, "The quick brown fox", font = 'times-new-roman', size = 30)

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
earth <- image_read("https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif")
earth <- image_scale(earth, "200")
length(earth)
head(image_info(earth))
print(earth)

rev(earth) %>% 
  image_flip() %>% 
  image_annotate("meanwhile in Australia", size = 20, color = "white")

## ------------------------------------------------------------------------
bigdata <- image_read('http://feelgrafix.com/data_images/out/28/1004158-data.jpg')
frink <- image_read("https://jeroenooms.github.io/images/frink.png")
logo <- image_read("https://www.r-project.org/logo/Rlogo.png")
img <- c(bigdata, logo, frink)
img <- image_scale(img, "400x400")
image_info(img)

## ------------------------------------------------------------------------
image_flatten(img)

## ------------------------------------------------------------------------
image_flatten(img, 'Add')
image_flatten(img, 'Modulate')
image_flatten(img, 'Minus')

## ------------------------------------------------------------------------
manual <- image_read('https://cran.r-project.org/web/packages/magick/magick.pdf')
length(manual)

# Convert the first page to PNG
image_convert(image_scale(manual[1], "1200"), "png")

## ------------------------------------------------------------------------
image_animate(image_scale(img, "200x200"), fps = 4, dispose = "previous")

## ------------------------------------------------------------------------
# Background image
logo <- image_read("https://www.r-project.org/logo/Rlogo.png")
background <- image_scale(logo, "400")

# Foreground image
banana <- image_read(system.file("banana.gif", package = "magick"))
front <- image_scale(banana, "300")

# Combine and flatten frames
frames <- lapply(as.list(front), function(x) image_flatten(c(background, x)))

# Turn frames into animation
animation <- image_animate(image_join(frames))
print(animation)

# Save as GIF
image_write(animation, "Rlogo-banana.gif")

