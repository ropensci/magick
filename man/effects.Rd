% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/effects.R
\name{effects}
\alias{effects}
\alias{image_despeckle}
\alias{image_reducenoise}
\alias{image_noise}
\alias{image_blur}
\alias{image_motion_blur}
\alias{image_charcoal}
\alias{image_oilpaint}
\alias{image_emboss}
\alias{image_implode}
\alias{image_negate}
\title{Image Effects}
\usage{
image_despeckle(image, times = 1L)

image_reducenoise(image, radius = 1L)

image_noise(image, noisetype = "gaussian")

image_blur(image, radius = 1, sigma = 0.5)

image_motion_blur(image, radius = 1, sigma = 0.5, angle = 0)

image_charcoal(image, radius = 1, sigma = 0.5)

image_oilpaint(image, radius = 1)

image_emboss(image, radius = 1, sigma = 0.5)

image_implode(image, factor = 0.5)

image_negate(image)
}
\arguments{
\item{image}{magick image object returned by \code{\link[=image_read]{image_read()}} or \code{\link[=image_graph]{image_graph()}}}

\item{times}{number of times to repeat the despeckle operation}

\item{radius}{radius, in pixels, for various transformations}

\item{noisetype}{string with a
\href{https://www.imagemagick.org/Magick++/Enumerations.html#NoiseType}{noisetype} value
from \link{noise_types}.}

\item{sigma}{the standard deviation of the Laplacian, in pixels.}

\item{angle}{angle, in degrees, for various transformations}

\item{factor}{image implode factor (special effect)}
}
\description{
High level effects applied to an entire image.
These are mostly just for fun.
}
\examples{
logo <- image_read("logo:")
image_despeckle(logo)
image_reducenoise(logo)
image_noise(logo)
image_blur(logo, 10, 10)
image_motion_blur(logo, 10, 10, 45)
image_charcoal(logo)
image_oilpaint(logo, radius = 3)
image_emboss(logo)
image_implode(logo)
image_negate(logo)
}
\seealso{
Other image: 
\code{\link{_index_}},
\code{\link{analysis}},
\code{\link{animation}},
\code{\link{attributes}()},
\code{\link{color}},
\code{\link{composite}},
\code{\link{defines}},
\code{\link{device}},
\code{\link{edges}},
\code{\link{editing}},
\code{\link{fx}},
\code{\link{geometry}},
\code{\link{morphology}},
\code{\link{ocr}},
\code{\link{options}()},
\code{\link{painting}},
\code{\link{segmentation}},
\code{\link{transform}()},
\code{\link{video}}
}
\concept{image}
