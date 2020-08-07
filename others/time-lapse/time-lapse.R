library(av) # Working with Audio and Video in R
library(here) # A Simpler Way to Find Your Files
library(tidyverse) # Easily Install and Load the 'Tidyverse'
library(lubridate) # Make Dealing with Dates a Little Easier

# Here there is a vector with the photos that will be employed for the time lapse
photos <- list.files(here("images", "edited"), pattern = "\\.jpg$", full.names = T)


# Filters for audio and video ---------------------------------------------

# It is possible to add effects for the audio and video, here you find two dataframes 
# with the available codecs and effect built-in the av package

# Video
encoders <- av::av_encoders()

# Audio
filters <- av::av_filters()

# Audio INFO
av_media_info("BREAKING_BAD_ALL_TIMELAPSES.mp3")

# Initial time to crop audio

start_time <- ms("04:47") %>% as.period(unit = "sec") %>%  as.numeric()
end_time   <- ms("05:07") %>% as.period(unit = "sec") %>%  as.numeric()

total_time <- end_time - start_time 

av_muxers() %>% filter(str_detect(name, 'mp'))

# Crop Audio
av_audio_convert(audio = "BREAKING_BAD_ALL_TIMELAPSES.mp3", 
                 output = "audio_time-lapse.mp3", format = "mp3",
                 start_time = start_time, total_time = total_time)

# Create Time-Lapse
av_encode_video(input = photos, framerate = 30, codec = "libx264", 
                audio = "audio_time-lapse.mp3", output = "street_lights.mp4")



