library(tidyverse) # Easily Install and Load the 'Tidyverse'
library(rayrender) # Build and Raytrace 3D Scenes
library(tweenr) # Interpolate Data for Smooth Animations


# Rotation of the object
x <- tween_numeric(c(10, 720), n = 330, ease = "cubic-out") %>% unlist()

# Repetead the first frame 30 times
angles <- c(0, x)

for(i in 1:length(angles)) {

generate_studio(depth = -50, curvature = 0, distance = -50) %>%
  add_object(obj_model(y = -4, filename = r_obj(),
                       scale_obj = 4, angle = c(0,angles[i],0),
                       material = diffuse(color = "steelblue"))) %>%
  add_object(objects = xy_rect(x = 0, y = 0, z = -10,
                               xwidth = 20, ywidth = 20,
                               material = diffuse(color = "#0d0ce3"))) %>%
  add_object(objects = yz_rect(x = -10, y = 0, z = 0,
                               ywidth = 20, zwidth = 20,
                               material = diffuse(color = "#e5e37e"))) %>%
  add_object(objects = xz_rect(x = 0, y = -10, z = 0,
                               xwidth = 20, zwidth = 20,
                               material = diffuse(color = "brown"))) %>%
  add_object(sphere(x = 0, y = 0, z = 150, radius = 4, angle = c(90, 0, 0),
                  material = light(intensity = 600))) %>%
  add_object(sphere(x = 150, y = 0, z = 0, radius = 4, angle = c(90, 0, 0),
                    material = light(intensity = 600))) %>%
  render_scene(samples = 400, lookfrom = c(40,30,50), clamp_value = 10, fov = 16,
               filename = sprintf("temp_img/duality%i.png", i),
               tonemap = "hbd")
  
  print(paste("Frame",formatC(i, digits = 2, format = "fg", flag = "0"), "successfully completed"))

}

# List files to create animation
png_files <- list.files("temp_img/", pattern = "*.png", full.names = T, ) %>% gtools::mixedsort()

# Repeat 1st frame before start rotating
files <- c(rep(png_files[1], 60*2), png_files)

# Create GIF
av::av_encode_video(files, 'output2.gif', framerate = 60,
                    codec = "gif", vfilter = "scale=400:240:force_original_aspect_ratio=decrease")

# Optimise GIF - Reduce size
system("gifsicle -O3 --lossy=80 output.gif -o output-optimized.gif")

