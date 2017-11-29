#See http://bioconductor.org/packages/devel/bioc/vignettes/EBImage/inst/doc/EBImage-introduction.html
if(require("EBImage")){
  images <- list.files(system.file("images", package="EBImage"), full.names = TRUE)
  for(path in images){
    img1 <- image_read(path)
    eb1 <- EBImage::readImage(path)
    img2 <- image_read(eb1)
    stopifnot(length(img1) == length(img2))
    buf1 <- image_data(img1, 'rgba')
    buf2 <- image_data(img2, 'rgba')
    stopifnot(all.equal(buf1, buf2))
    buf3 <- image_read(buf1)[[1]]
    stopifnot(all.equal(buf1, buf3))

    eb2 <- as_EBImage(img2)
    dimnames(eb2@.Data) <- dimnames(eb1@.Data)
    stopifnot(all.equal(eb1, eb2))
    cat(basename(path), "OK!\n")
  }
}
