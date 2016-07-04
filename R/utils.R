read_image <- function(image){
  if(is.character(image)){
    image <- normalizePath(image, mustWork = TRUE)
    return(readBin(image, raw(), file.info(image)$size))
  } else if(is.raw(image)) {
    return(image)
  } else {
    stop("Parameter 'image' must be file path or raw vector with image data")
  }
}

write_image <- function(output, image, format){
  if(is.character(image)){
    outfile <- paste0(sub("\\.[a-zA-Z]+$", "", image), ".", format)
    writeBin(output, outfile)
    return(outfile)
  } else {
    return(output)
  }
}
