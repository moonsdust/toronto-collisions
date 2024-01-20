#### Preamble ####
# Purpose: Cleans unedited collisions data and unedited ward profiles data
# to create clean, usable CSV files with relevant columns.
# Author: Emily Su
# Date: 25 January 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse has been installed by running 00-install_packages.R
# and datasets have been downloaded by running 01-download_data.R. 

#### Workspace setup ####
library(tidyverse)

#### Clean data ####

# Dataset 1 (Expected Columns)
raw_data <- read_csv("inputs/data/plane_data.csv")

cleaned_data <-
  raw_data |>
  janitor::clean_names() |>
  select(wing_width_mm, wing_length_mm, flying_time_sec_first_timer) |>
  filter(wing_width_mm != "caw") |>
  mutate(
    flying_time_sec_first_timer = if_else(flying_time_sec_first_timer == "1,35",
                                   "1.35",
                                   flying_time_sec_first_timer)
  ) |>
  mutate(wing_width_mm = if_else(wing_width_mm == "490",
                                 "49",
                                 wing_width_mm)) |>
  mutate(wing_width_mm = if_else(wing_width_mm == "6",
                                 "60",
                                 wing_width_mm)) |>
  mutate(
    wing_width_mm = as.numeric(wing_width_mm),
    wing_length_mm = as.numeric(wing_length_mm),
    flying_time_sec_first_timer = as.numeric(flying_time_sec_first_timer)
  ) |>
  rename(flying_time = flying_time_sec_first_timer,
         width = wing_width_mm,
         length = wing_length_mm
         ) |> 
  tidyr::drop_na()

#### Save data ####
write_csv(cleaned_data, "outputs/data/analysis_data.csv")
