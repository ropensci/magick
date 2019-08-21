#' RStudio Graphics AutoViewer
#'
#' This enables a \link{addTaskCallback} that automatically updates the viewer after
#' the state of a magick graphics device has changed. This is enabled by default in
#' RStudio.
#'
#' @export
#' @rdname autoviewer
#' @name autoviewer
#' @examples
#' # Only has effect in RStudio (or other GUI with a viewer):
#' autoviewer_enable()
#'
#' img <- magick::image_graph()
#' plot(1)
#' abline(0, 1, col = "blue", lwd = 2, lty = "solid")
#' abline(0.1, 1, col = "red", lwd = 3, lty = "dotted")
#'
#' autoviewer_disable()
#' abline(0.2, 1, col = "green", lwd = 4, lty = "twodash")
#' abline(0.3, 1, col = "black", lwd = 5, lty = "dotdash")
#'
#' autoviewer_enable()
#' abline(0.4, 1, col = "purple", lwd = 6, lty = "dashed")
#' abline(0.5, 1, col = "yellow", lwd = 7, lty = "longdash")
autoviewer_enable <- function(){
  autoviewer$enable()
}

#' @export
#' @rdname autoviewer
autoviewer_disable <- function(){
  autoviewer$disable()
}

# Automatically update viewer after graphics events have finished
autoviewer <- local({
  id <- NULL
  this <- environment()
  enable <- function(){
    this$disable()
    magick_device_pop() # clear existing plots
    if(interactive() && is.function(getOption("viewer"))){
      id <<- addTaskCallback(function(...){
        tryCatch({
          dirty <- magick_device_pop()
          if(length(dirty))
            print(dirty, info = FALSE)
        }, error = function(...){});
        return(TRUE)
      })
    }
  }
  disable <- function(...){
    if(length(id))
      removeTaskCallback(id)
  }
  reg.finalizer(this, this$disable, onexit = TRUE)
  this
})
