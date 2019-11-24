#marshmallow
library(tidyverse)
library(lubridate)

# hypothesis: main effects on energy use vary with energy type, initial reading, building construction, building usage, time of day, day of week, day of year, site

# data report section
train <- data.table::fread('./input/train.csv') %>%
  mutate(timestamp = ymd_hms(timestamp))

buildings <- data.table::fread('./input/building_metadata.csv')

weather_train <- data.table::fread('./input/weather_train.csv')

# data modeling section
development <- train %>%
  mutate(hour = hour(timestamp),
         day_of_week = wday(timestamp),
         day_of_year = yday(timestamp)) %>%
  group_by(building_id,
           meter) %>%
  mutate(cumsum_reading = cumsum(meter_reading)) %>%
  ungroup %>%
  filter(cumsum_reading != 0) %>%
  select(building_id,
         meter,
         hour,
         day_of_week,
         day_of_year,
         meter_reading) %>%
  as.data.frame %>%
  as.matrix

