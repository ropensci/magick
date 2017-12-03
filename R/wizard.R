#' Example Images
#' 
#' Example images included with ImageMagick:
#' 
#'  - `logo`: ImageMagick Logo, 640x480
#'  - `wizard`: ImageMagick Wizard, 480x640
#'  - `rose` : Picture of a rose, 70x46	
#'  - `granite` : Granite texture pattern, 128x128
#' 
#' @rdname wizard
#' @name wizard
#' @aliases logo rose granite
#' @export logo wizard rose granite
delayedAssign('logo', image_read("logo:"))
delayedAssign('wizard', image_read("wizard:"))
delayedAssign('rose', image_read("rose:"))
delayedAssign('granite', image_read("granite:"))
