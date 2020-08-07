library(tidyverse) # Easily Install and Load the 'Tidyverse'
library(ggforce) # Accelerating 'ggplot2'
library(gganimate) # A Grammar of Animated Graphics
library(pals) # Color Palettes, Colormaps, and Tools to Evaluate Them
library(hrbrthemes) # Additional Themes, Theme Components and Utilities for 'ggplot2' 

set.seed(111)

### 1M random points over the canvas
random_points <-
  tibble(x = runif(1000000, min = -1, max = 1), 
         y = runif(1000000, min = -1, max = 1),
         r = ifelse(x^2 + y^2 <= 1, "in", 'out'))

random_points <-
  random_points %>% 
  mutate(n      = 1:n(),
         in_out = case_when(r == "in" ~ 1,
                            TRUE ~ 0),
         pi_est = 4*cumsum(in_out)/n,
         ten_pow = cut(n, breaks = 10^(0:6), labels = 10^(1:6), include.lowest = TRUE) %>% 
           as.character %>% as.numeric()) 

### Pi estimations to some powers of ten
pi_ten_pow <-
  random_points %>% 
  group_by(ten_pow) %>% 
  filter(row_number() == n()) %>% 
  select(-(x:y))

### Circle shape
circle <- 
  tibble(theta = seq(0, 2*pi, length.out = 50),
         x = cos(theta),
         y = sin(theta)) %>% 
  select(-theta)

### Facet plot powers of ten

powers.of.ten <-
ggplot(random_points) +
  geom_point(aes(x, y, color = r, group = seq_along(ten_pow)),
             size = 0.1, alpha = 0.7, show.legend = FALSE) +
  geom_path(data = circle, aes(x = x, y = y)) +
  geom_rect(aes(xmin = -1, xmax = 1, ymin = -1, ymax = 1), size = 0.2,
            color = "red", fill = "transparent") +
  geom_label(data = pi_ten_pow, parse = TRUE,
             aes(0, -1.25, label = paste("pi ==" , sprintf("%.5f", pi_est))),
             size = 5, family = "Bebas Neue") +
  coord_fixed(ylim = c(-1.5, NA)) +
  facet_wrap(~ paste(format(ten_pow, scientific = FALSE), "points"), nrow = 2) +
  scale_color_manual(values = tol(2)) +
  theme_void() +
  theme(panel.spacing = unit(.5, "lines")) +
  theme(axis.text.y = element_blank(),
        strip.text = element_text(hjust = 0,
                                  family = "Bebas Neue", size = 14))

ggsave(filename = "powers-of-ten.png",
       plot = powers.of.ten,
       # dpi = 100,
       scale = 0.6,
       width = 10,
       height = 9)

### Simulation 1M random points

animation_canvas <- 
ggplot(random_points %>% slice(1:10000)) +
  geom_point(aes(x, y, color = r, group = seq_along(ten_pow)),
             size = 0.5, alpha = 0.7, show.legend = FALSE) +
  geom_path(data = circle, aes(x = x, y = y)) +
  geom_rect(aes(xmin = -1, xmax = 1, ymin = -1, ymax = 1),
            color = "red", fill = "transparent") +
  geom_label(parse = TRUE,
             aes(0, -1.15, label = paste("pi ==" , sprintf("%.5f", pi_est))),
             size = 5, family = "Bebas Neue") +
  # labs(title = paste(format(pi_est, scientific = FALSE), "points")) +
  labs(title = '{format(frame_along, scientific = FALSE, big.mark = ",")} points') +
  coord_fixed(ylim = c(-1.25, NA)) +
  # facet_wrap(~ paste(format(ten_pow, scientific = FALSE), "points"), nrow = 2) +
  scale_color_manual(values = tol(2)) +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5,
                                  family = "Bebas Neue", size = 16)) +
  transition_reveal(n)


options(gganimate.dev_args = list(res = 135))

animation_canvas <- 
animate(animation_canvas,
        width = 600, # 900px wide
        height = 600, # 600px high
        duration = 10,
        renderer = gifski_renderer()
        # renderer = av_renderer()
        )

anim_save(filename = "animation_canvas.gif", 
          animation = animation_canvas)

### Evolution of the estimate

approx_pi <-
random_points %>%
  filter(n %% 1000 == 0) %>%
  ggplot(aes(x = n, y = pi_est)) +
  geom_hline(yintercept = pi, linetype = 2, color = "red") +
  geom_point() +
  geom_label(parse = TRUE,
             aes(8e5, 3.20, label = paste("pi ==" , sprintf("%.5f", pi_est))),
             size = 5, family = "Bebas Neue") +
  labs(x = "Number of points",
       y = expression(paste(pi~phantom(0), "Estimation"))) +
  geom_line(color  = "#4477AA") +
  theme_ipsum() +
  scale_x_continuous(labels = scales::comma) +
  theme(text = element_text(family = "Bebas Neue", size = 16),
        axis.title.x = element_text(family = "Bebas Neue", size = 14),
        axis.title.y = element_text(family = "Bebas Neue", size = 14)) +
transition_reveal(n)

options(gganimate.dev_args = list(res = 135))

approx_pi <-
animate(approx_pi,
        width = 600, # 900px wide
        height = 600, # 600px high
        duration = 10,
        detail = 10,
        type = "cairo",
        renderer = gifski_renderer()
        ) 

anim_save(filename = "approx_pi.gif",
          animation = approx_pi)
