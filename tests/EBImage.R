#See http://bioconductor.org/packages/devel/bioc/vignettes/EBImage/inst/doc/EBImage-introduction.html
images <- list.files(system.file("images", package="EBImage"), full.names = TRUE)
for(path in images){
  img1 <- image_read(path)
  img2 <- image_read(EBImage::readImage(path))
  stopifnot(length(img1) == length(img2))
  buf1 <- image_write(img1, format = 'rgba', depth = 8)
  buf2 <- image_write(img2, format = 'rgba', depth = 8)
  stopifnot(all.equal(buf1, buf2))
}
