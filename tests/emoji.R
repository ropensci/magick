library(emojifont)
library(magick)
set.seed(2016-03-09)
fa <- fontawesome(c('fa-github', 'fa-weibo', 'fa-twitter', 'fa-android', 'fa-coffee'))
d <- data.frame(x=rnorm(20),
                y=rnorm(20),
                label=sample(fa, 20, replace=T))


img <- magick::image_graph(res = 96)
ggplot(d, aes(x, y, color=label, label=label)) +
  geom_text(family='fontawesome-webfont', size=6)+
  xlab(NULL)+ylab(NULL) +
  theme(legend.text=element_text(family='fontawesome-webfont'))
dev.off()
print(img)
