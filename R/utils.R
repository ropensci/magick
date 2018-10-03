#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

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

replace_url <- function(path){
  if(is_url(path)){
    pattern <- "\\[[-,0-9]+\\]$"
    suffix <- regmatches(path, regexpr(pattern, path))
    path <- sub(pattern, "", path)
    paste0(download_url(path), suffix)
  } else if(grepl("^[^/\\]+:$", path)) {
    # demo images e.g. "logo:" or "wizard:"
    return(path)
  } else {
    normalizePath(path, mustWork = FALSE)
  }
}

download_url <- function(url){
  req <- curl::curl_fetch_memory(url)
  if(req$status >= 400)
    stop(sprintf("Failed to download %s (HTTP %d)", url, req$status))
  headers <- curl::parse_headers_list(req$headers)
  ctype <- headers[['content-type']]
  matches <- match(ctype, mimetypes$type)
  extension <- if(length(matches) && !is.na(matches) && !grepl("(text|octet)", ctype)){
    sub("*.", ".", mimetypes$pattern[matches[1]], fixed = TRUE)
  } else {
    basename(url)
  }
  filename <- tempfile(fileext = extension)
  writeBin(req$content, filename)
  return(filename)
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
  if(magick_image_dead(image))
    stop("Image pointer is dead. You cannot save or cache image objects between R sessions.", call. = FALSE)
}

df_to_tibble <- function(df){
  stopifnot(inherits(df, 'data.frame'))
  class(df) <- c("tbl_df", "tbl", "data.frame")
  df
}
