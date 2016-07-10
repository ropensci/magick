# magick

##### *Simple Image-Processing in R*

[![Build Status](https://travis-ci.org/jeroenooms/magick.svg?branch=master)](https://travis-ci.org/jeroenooms/magick)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/jeroenooms/magick?branch=master&svg=true)](https://ci.appveyor.com/project/jeroenooms/magick)
[![Coverage Status](https://codecov.io/github/jeroenooms/magick/coverage.svg?branch=master)](https://codecov.io/github/jeroenooms/magick?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/magick)](http://cran.r-project.org/package=magick)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/magick)](http://cran.r-project.org/web/packages/magick/index.html)
[![Github Stars](https://img.shields.io/github/stars/jeroenooms/magick.svg?style=social&label=Github)](https://github.com/jeroenooms/magick)

> Bindings to the ImageMagick image-processing library, the
  most comprehensive open-source image processing package available.

## Documentation

About the underlying library:

 - [Magick++ API Documentation](https://www.imagemagick.org/Magick++/Documentation.html)

## Hello World

```r
# Create a PNG
png_file <- tempfile(fileext = ".png")
png(png_file)
plot(cars)
dev.off()

# Convert to formats
image <- magick::image_read(png_file)
magick::image_write(image, "jpg", "output.jpg")
magick::image_write(image, "gif", "output.gif")
magick::image_write(image, "pdf", "output.pdf")

```

## Installation

Binary packages for __OS-X__ or __Windows__ can be installed directly from CRAN:

```r
install.packages("magick")
```

Installation from source on Linux or OSX requires the imagemagick [`Magick++`](https://www.imagemagick.org/Magick++/Documentation.html) library. On __Debian or Ubuntu__ install [libmagick++-dev](https://packages.debian.org/testing/libmagick++-dev):

```
sudo apt-get install -y libmagick++-dev
```

On __Fedora__,  __CentOS or RHEL__ we need [ImageMagick-c++-devel](https://apps.fedoraproject.org/packages/ImageMagick-c++-devel):

```
sudo yum install ImageMagick-c++-devel
````

On __OS-X__ use [magick](https://github.com/Homebrew/homebrew-core/blob/master/Formula/imagemagick.rb) from Homebrew:

```
brew install imagemagick
```

See the R `?magick` manual page for information on how to install additional dictionaries.


[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
