# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Name:     UNIT CIRCLE. SINE AND COSINE FUNCTIONS
# Author:   Iván Mauricio Cely Toro
# Date:     07-04-2020
# e-mail:   mauriciocelytoro@hotmail.com
# Version:  0.0
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# REQUIRED PACKAGES -------------------------------------------------------
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

library(tidyverse) # Easily Install and Load the 'Tidyverse' 
library(gganimate) # A Grammar of Animated Graphics
library(hrbrthemes) # Additional Themes, Theme Components and Utilities for 'ggplot2'

df <- 
  tibble(theta = seq(0, 2*pi, length.out = 100), ### Angle
         x     = cos(theta), ### x-component
         y     = sin(theta) ### y-component
  )

### Add frame column for each step of the animation
df <-
  df %>%
  mutate(frame = 1:n()) %>%
  relocate(frame)

### Labels superior axis in radians
rad_labels <-  c(expression(phantom(over(1,1))*0*phantom(over(1,1))),
                 expression(frac(pi, 4)),
                 expression(frac(pi, 2)),
                 expression(frac(3*pi, 4)),
                 expression(phantom(over(1,1))*pi*phantom(over(1,1))),
                 expression(frac(5*pi, 4)),
                 expression(frac(3*pi, 2)),
                 expression(frac(7*pi, 4)),
                 expression(phantom(over(1,1))*2*pi*phantom(over(1,1)))
)


sine <- 
  ggplot(df) + 
  ### Circle
  geom_point(aes(x, y)) +
  geom_path(aes(x, y)) +
  ### Angle arrow
  geom_segment(aes(x = 0, y = 0, xend = x, yend = y), arrow = arrow(length = unit(1.7, "mm"), type = "closed")) +
  geom_segment(aes(x = 2, y = 0, xend = Inf, yend = 0), linetype = "dashed") +
  ### Red point and its line
  geom_point(aes(x = 1.5, y = y), color = "red", size = 2) +
  geom_vline(xintercept = 2) +
  ### Connecting lines circle and functions
  geom_segment(aes(x = x, y = y, xend = theta + 2, yend = y)) +
  geom_segment(aes(x = 0, y = 0, xend = 0, yend = y), color = "steelblue") +
  geom_segment(aes(x = x, y = 0, xend = x, yend = y), color = "steelblue", linetype = 2) +
  geom_text(aes(x = -0.12, y = 0.5, label = "sin(theta)"), color = "steelblue", parse = T, angle = 90) +
  geom_segment(aes(x = 0, y = 0, xend = x, yend = 0), color = "#FAAB18") +
  geom_segment(aes(x = 0, y = y, xend = x, yend = y), color = "#FAAB18", linetype = 2) +
  geom_text(aes(x = 0.5, y = -0.12, label = "cos(theta)"), color = "#FAAB18", parse = T) +
  geom_path(aes(theta + 2, y), color = "steelblue") +
  geom_point(aes(x = theta + 2, y =  y), color = "steelblue") +
  geom_path(aes(theta + 2, x), color = "#FAAB18") +
  geom_point(aes(x = theta + 2, y =  x), color = "#FAAB18") +
  coord_fixed(expand = F, xlim = c(-1.1, 8.4), ylim = c(-1.1, 1.1)) +
  scale_x_continuous(breaks = c(-1:1, seq(2, (2*pi) + 2, length.out = 9)),
                     labels = c(-1:1, seq(0, 360, length.out = 9)), name = "degrees",
                     sec.axis = sec_axis(trans = ~.*1,
                                         breaks = c(rep(NA,3), seq(2, (2*pi)+2, length.out = 9)),
                                         labels =  c(-1:1, rad_labels),
                                         name =   "radians")) +
  labs(title = "Unit Circle - Sine and Cosine Functions",
       subtitle = "Sine and cosine can be generated by projecting the tip of a vector onto the y-axis and x-axis as the\n vector rotates about the origin.",
       caption = "Created by @Mauricio_Cely",
       y = "") +
  theme_ipsum() +
  theme(plot.margin = margin(-1, 1, -1, 0, unit = "cm"), 
        plot.subtitle = element_text(face = "italic")) +
  transition_reveal(along = frame)


animate(sine,
        width = 1600, # 900px wide
        height = 800, # 600px high
        duration = 10,
        renderer = gifski_renderer(),
        res = 200) # 10 frames per second

anim_save("unit_circle.gif")