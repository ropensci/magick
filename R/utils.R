#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

is_url <- function(path){
  grepl("^https?://", path)
}

is_svg <- function(path){
  # svg files ending in "</svg>" with or without whitespace following it
  grepl("<\\/svg>\\s?$", path)
}

replace_url <- function(path){
  if(is_svg(path))
    return(path)
  if(is_url(path)){
    pattern <- "\\[[-,0-9]+\\]$"
    suffix <- regmatches(path, regexpr(pattern, path))
    path <- sub(pattern, "", path)
    paste0(download_url(path), suffix)
  } else if(grepl("^[^/\\]+:($|[^/\\])", path)) {
    # demo images e.g. "logo:" or "wizard:" or "cr2:myfile.cr2"
    return(path)
  } else {
    normalizePath(path, mustWork = FALSE)
  }
}

# Uses file extension from HTTP content-type if available to help IM guess type.
download_url <- function(url){
  tmp <- tempfile(fileext = sub("\\?.*", "", basename(url)))
  if(requireNamespace('curl', quietly = TRUE)){
    h <- curl::new_handle()
    curl::curl_download(url, tmp, handle = h)
    headers <- curl::parse_headers_list(curl::handle_data(h)$headers)
    ctype <- headers[['content-type']]
    matches <- match(ctype, mimetypes$type)
    if(length(matches) && !is.na(matches) && !grepl("(text|octet)", ctype)){
      extension <- sub("*.", ".", mimetypes$pattern[matches[1]], fixed = TRUE)
      outfile <- tempfile(fileext = extension)
      file.rename(tmp, outfile)
      return(outfile)
    }
  } else {
    utils::download.file(url, tmp, quiet = TRUE) #Fallback for webR
  }
  return(tmp)
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

is_windows <- function(){
  identical(.Platform$OS.type, 'windows')
}
