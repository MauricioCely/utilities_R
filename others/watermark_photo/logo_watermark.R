library(tidyverse) # Easily Install and Load the 'Tidyverse'
library(extrafont) # Tools for using fonts
library(grid) # The Grid Graphics Package
library(magick) # Advanced Graphics and Image-Processing in R
library(rsvg) # Render SVG Images into PDF, PNG, PostScript, or Bitmap Arrays

# Load image Prism
prism <- image_read_svg("prism_gray.svg") 
prism <- prism[[1]]
# img[1,,] <- as.raw(70)
# img[2,,] <- as.raw(130)
# img[3,,] <- as.raw(180)
prism[4,,] <- as.raw(as.integer(prism[4,,]) * 0.2)
image_read(prism) -> prism
prism_pic <- rasterGrob(prism, interpolate = TRUE)

### Plot Watermark Photos

ggplot() +
  coord_fixed(xlim = c(-20,20), ylim = c(-7, 7)) +
  annotation_custom(prism_pic, xmin = -16, xmax = 16, ymin = -12, ymax = 14) +
  annotate("text", x = 0, y = 2, alpha = 0.8,
           label = "MAURICIO CELY", family = "Plateia", size = 42, lineheight = 1, colour = "white") +
  annotate("text", x = 0, y = -2, alpha = 1,
           label = "Photography", family = "Roboto Thin", size = 35, lineheight = 1, colour = "#ccff00") +
  theme_void() +
  theme(panel.background = element_rect(fill = "#252a32"))

ggsave(filename = "logo_photo.png",
       plot = last_plot(),
       # height = 70,  width = 200,
       # units = "mm", dpi = 20, scale = 2.5,
       height = 7,
       width = 20,
       units = "in",
       dpi = 72)

