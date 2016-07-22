read_path <- function(path){
  image <- if(is.character(path)){
    if(is_url(path)){
      read_url(path)
    } else {
      read_file(path)
    }
  } else if(is.raw(path)){
    path
  } else {
    stop("Parameter 'image' must be an image object, file path or raw vector with image data")
  }
  return(image)
}

is_url <- function(path){
  grepl("https?://", path)
}

read_url <- function(path){
  req <- curl::curl_fetch_memory(path)
  if(req$status >= 400)
    stop(sprintf("Failed to download %s (HTTP %d)", path, req$status))
  return(req$content)
}

read_file <- function(path){
  readBin(normalizePath(path, mustWork = TRUE), raw(), file.info(path)$size)
}

assert_image <- function(image){
  if(!inherits(image, "magick-image"))
    stop("The 'image' argument is not a magick image object.", call. = FALSE)
}
