library(xml2)
doc <- read_xml('https://raw.githubusercontent.com/ImageMagick/ImageMagick/master/www/source/mime.xml')
nodes <- xml_find_all(xml_children(doc), "//*[@pattern]")
mimetypes <- data.frame(
  type = xml_attr(nodes, "type"),
  description = xml_attr(nodes, "description"),
  pattern = xml_attr(nodes, "pattern"),
  stringsAsFactors = FALSE
)
save(mimetypes, file = "R/sysdata.rda")

