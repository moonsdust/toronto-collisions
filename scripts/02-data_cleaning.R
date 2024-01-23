#### Preamble ####
# Purpose: Cleans unedited collisions data and unedited ward profiles data
# to create clean, usable CSV files with relevant columns.
# Author: Emily Su
# Date: 23 January 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse has been installed by running 00-install_packages.R
# and datasets have been downloaded by running 01-download_data.R.

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)
library(sf)

#### Clean data ####

## Read in datasets ##
raw_collisions_data <- read_csv("inputs/data/unedited_collisions_data.csv", show_col_types = FALSE)
raw_ward_profiles_data <- read_csv("inputs/data/unedited_ward_profiles_data.csv", show_col_types = FALSE)
raw_city_ward_data <- readRDS("inputs/data/city_wards.RDS")

# Clean the column names for city ward data
cleaned_city_ward_data <- clean_names(raw_city_ward_data)

## For collisions dataset ##
# Clean the column names for collision data
cleaned_collisions_data <- clean_names(raw_collisions_data)

# Select our desired columns from this dataset that we will want for 
# the new, cleaned dataset 
cleaned_collisions_data <-
  cleaned_collisions_data |>
  filter(occ_year >= 2017 & occ_year <= 2023) |>
  select(
    occ_year,
    fatalities,
    injury_collisions,
    pd_collisions,
    ftr_collisions, 
    long_wgs84,
    lat_wgs84, 
    neighbourhood_158,
    pedestrian
  )

# Renaming occ_year column to year
cleaned_collisions_data <-
  cleaned_collisions_data |>
  rename( # Left side is the new name and the right side is the old name
    year = occ_year,
    pedestrian_involved = pedestrian
  )

# Get rid of all rows with NA 
cleaned_collisions_data <- na.omit(cleaned_collisions_data)

# Replace NO with 0 and YES with 1 and convert to numeric
cleaned_collisions_data$injury_collisions <- str_replace(
  cleaned_collisions_data$injury_collisions, "YES", "1")
cleaned_collisions_data$injury_collisions <- str_replace(
  cleaned_collisions_data$injury_collisions, "NO", "0")

cleaned_collisions_data$pd_collisions <- str_replace(
  cleaned_collisions_data$pd_collisions, "YES", "1")
cleaned_collisions_data$pd_collisions <- str_replace(
  cleaned_collisions_data$pd_collisions, "NO", "0")

cleaned_collisions_data$ftr_collisions <- str_replace(
  cleaned_collisions_data$ftr_collisions, "YES", "1")
cleaned_collisions_data$ftr_collisions <- str_replace(
  cleaned_collisions_data$ftr_collisions, "NO", "0")

# Replace N\A and "NO' with a "No" and "YES" with a "Yes"
cleaned_collisions_data$pedestrian_involved[cleaned_collisions_data$pedestrian_involved != "YES"] <- "No"
cleaned_collisions_data$pedestrian_involved[cleaned_collisions_data$pedestrian_involved == "YES"] <- "Yes"

# Convert columns from character to numeric
cleaned_collisions_data$injury_collisions <- as.numeric(cleaned_collisions_data$injury_collisions)
cleaned_collisions_data$pd_collisions <- as.numeric(cleaned_collisions_data$pd_collisions)
cleaned_collisions_data$ftr_collisions <- as.numeric(cleaned_collisions_data$ftr_collisions)

# Convert column pedestrian_involved from character to numeric
cleaned_collisions_data$pedestrian_involved <- as.character(cleaned_collisions_data$pedestrian_involved)

# Dataset 1 (number of collisions, collision types, what year the collision occurred, 
# and number of pedestrians involved in the crash)
# Expected Columns: year | collision_type | num_of_collisions | num_of_pedestrians
# Create a new dataset
dataset_1 <-
  cleaned_collisions_data |>
  select(-c(long_wgs84,lat_wgs84, neighbourhood_158)) |>
  group_by(year, fatalities, injury_collisions, pd_collisions, ftr_collisions) |>
  mutate(num = n()) |> # count number of rows based on premise and year
  rename(num_of_collisions = num) |>
  mutate(
    num_of_pedestrians = sum(pedestrian_involved == "Yes")
  ) |>
  unique() |> # This will filter out repeated rows
  filter(
    (fatalities == 1 & injury_collisions == 0 & pd_collisions == 0 & ftr_collisions == 0) |
      (fatalities == 0 & injury_collisions == 1 & pd_collisions == 0 & ftr_collisions == 0) |
      (fatalities == 0 & injury_collisions == 0 & pd_collisions == 1 & ftr_collisions == 0) |
      (fatalities == 0 & injury_collisions == 0 & pd_collisions == 0 & ftr_collisions == 1)
    ) # Only include rows that is 1 in only one of the 4 columns 

# Add a new column collision_type by matching current columns to be values of this new column, 
# Remove the columns `fatalities`, `injury_collisions`, `pd_collisions`, `ftr_collisions`, and
# Rearrange columns 
dataset_1 <- 
  dataset_1 |>
  mutate( 
    collision_type = 
      case_when( #  
      (fatalities == 1 & injury_collisions == 0 & pd_collisions == 0 & ftr_collisions == 0) ~ "Fatal",
      (fatalities == 0 & injury_collisions == 1 & pd_collisions == 0 & ftr_collisions == 0) ~ "Personal Injury", 
      (fatalities == 0 & injury_collisions == 0 & pd_collisions == 1 & ftr_collisions == 0) ~ "Property Damage", 
      (fatalities == 0 & injury_collisions == 0 & pd_collisions == 0 & ftr_collisions == 1) ~ "Fail to Remain", 
      TRUE ~ "None"
      )
    ) |>
  ungroup() |>
  select(-c(fatalities, injury_collisions, pd_collisions, ftr_collisions)) |> # Remove columns
  select(year, collision_type, num_of_collisions, num_of_pedestrians) # Rearrange columns in desired order  


# Dataset 2 (cleaned_ward_data)
# Expected columns: ward_num | ward_name | pop_num | avg_income
# Clean current column names
cleaned_ward_data <- clean_names(raw_ward_profiles_data)

# Get row that contains population number 
ward_pop_size_row <- 
  cleaned_ward_data |> 
  filter(x2021_one_variable_city_of_toronto_profiles == "Total - Age")
# Convert row to a column 
ward_pop_size <- 
  ward_pop_size_row |>
  t() |> # Convert 1-row matrix into a 1-column matrix 
  c() |> # Convert to a vector
  tibble() |> # Change into a tibble
  slice(-1) |> # Remove the first two rows 
  slice(-1) |>
  rename( # Left side is the new name and the right side is the old name
    pop_num = "c(t(ward_pop_size_row))"
  ) |>
  mutate(
    ward_num = c(1:25), 
    ward_name = c("Etobicoke North", 
                   "Etobicoke Centre", 
                   "Etobicoke-Lakeshore", 
                   "Parkdale-High Park", 
                   "York South-Weston", 
                   "York Centre", 
                   "Humber River-Black Creek",
                   "Eglinton-Lawrence", 
                   "Davenport", 
                   "Spadina-Fort York", 
                   "University-Rosedale", 
                   "Toronto-St. Paul’s", 
                   "Toronto Centre", 
                   "Toronto-Danforth", 
                   "Don Valley West", 
                   "Don Valley East",
                   "Don Valley North", 
                   "Willowdale", 
                   "Beaches-East York", 
                   "Scarborough Southwest", 
                   "Scarborough Centre",
                   "Scarborough-Agincourt",
                   "Scarborough North", 
                   "Scarborough-Guildwood",
                   "Scarborough-Rouge Park")
  )

# Get row that contains the average household income
ward_avg_income_row <- 
  cleaned_ward_data |> 
  filter(x2021_one_variable_city_of_toronto_profiles == "Total - Household total income groups in 2020 for private households - 25% sample data")
# Convert row to a column 
ward_avg_income <- 
  ward_avg_income_row |>
  t() |> # Convert 1-row matrix into a 1-column matrix
  c() |> # Convert to a vector
  tibble() |> # Change into a tibble
  slice(-1) |> # Remove the first row 
  slice(-1) |>
  rename( # Left side is the new name and the right side is the old name
    avg_income = "c(t(ward_avg_income_row))"
  ) |> 
  mutate(
    ward_num = c(1:25), 
    ward_name_avg = c("Etobicoke North", 
                   "Etobicoke Centre", 
                   "Etobicoke-Lakeshore", 
                   "Parkdale-High Park", 
                   "York South-Weston", 
                   "York Centre", 
                   "Humber River-Black Creek",
                   "Eglinton-Lawrence", 
                   "Davenport", 
                   "Spadina-Fort York", 
                   "University-Rosedale", 
                   "Toronto-St. Paul’s", 
                   "Toronto Centre", 
                   "Toronto-Danforth", 
                   "Don Valley West", 
                   "Don Valley East",
                   "Don Valley North", 
                   "Willowdale", 
                   "Beaches-East York", 
                   "Scarborough Southwest", 
                   "Scarborough Centre",
                   "Scarborough-Agincourt",
                   "Scarborough North", 
                   "Scarborough-Guildwood",
                   "Scarborough-Rouge Park")
  )

# Convert columns from character to numeric
ward_avg_income$avg_income <- as.numeric(ward_avg_income$avg_income)
ward_pop_size$pop_num <- as.numeric(ward_pop_size$pop_num)

# Join ward_pop_size, and ward_avg_income_row into a single tibble 
cleaned_ward_data <- 
  ward_pop_size |>
  right_join(ward_avg_income, by = "ward_num") |>
  select(ward_num, ward_name, pop_num, avg_income) # Rearrange order

# Dataset 3 (Contains data of collision type, their longitude and latitude, 
# neighbourhood of collision, and number of collisions of each neighbourhood
# from 2017 to 2023)
# Expected: year | collision_type | long | lat | neighbourhood | pedestrian_involved
# num_of_collisions | yearly_collision_num | total_collisions_2017_2023 

dataset_3 <- 
  cleaned_collisions_data |>
  unique() |> # This will filter out repeated rows  
  filter((fatalities == 1 & injury_collisions == 0 & pd_collisions == 0 & ftr_collisions == 0) |
           (fatalities == 0 & injury_collisions == 1 & pd_collisions == 0 & ftr_collisions == 0) |
           (fatalities == 0 & injury_collisions == 0 & pd_collisions == 1 & ftr_collisions == 0) |
           (fatalities == 0 & injury_collisions == 0 & pd_collisions == 0 & ftr_collisions == 1)
  )|> # Only include rows that is 1 in only one of the 4 columns 
  # Add a new column collision_type by matching current columns to be values of this new column, 
  # Remove the columns `fatalities`, `injury_collisions`, `pd_collisions`, `ftr_collisions`, and
  # Rearrange columns 
  mutate( 
    collision_type = 
      case_when(
        (fatalities == 1 & injury_collisions == 0 & pd_collisions == 0 & ftr_collisions == 0) ~ "Fatal",
        (fatalities == 0 & injury_collisions == 1 & pd_collisions == 0 & ftr_collisions == 0) ~ "Personal Injury", 
        (fatalities == 0 & injury_collisions == 0 & pd_collisions == 1 & ftr_collisions == 0) ~ "Property Damage", 
        (fatalities == 0 & injury_collisions == 0 & pd_collisions == 0 & ftr_collisions == 1) ~ "Fail to Remain", 
        TRUE ~ "None"
      )
  ) |>
  select(-c(fatalities, injury_collisions, pd_collisions, ftr_collisions)) |> # Remove columns
  select(year, collision_type, long_wgs84, lat_wgs84, neighbourhood_158, pedestrian_involved) |> # Rearrange columns in desired order  
  rename ( # Left side is the new name and the right side is the old name
    neighbourhood = neighbourhood_158,
    long = long_wgs84,
    lat = lat_wgs84
  ) |>
  group_by(neighbourhood, collision_type) |>
  mutate(num = n()) |> # count number of rows based on neighbourhood and collision type
  # Create a new column for the number of collisions for the neighbourhood for each 
  # type of collision (2017 to 2023)
  rename(num_of_collisions = num) |>
  ungroup() |>
  group_by(neighbourhood, year) |>
  mutate(num = n()) |> # count number of rows based on neighbourhood and year
  # Create a new column for the yearly collisions number for the neighbourhood (2017 to 2023)
  rename(yearly_collision_num = num) |>
  ungroup() |>
  group_by(neighbourhood) |> # count number of rows based on neighbourhood
  mutate(num = n()) |> 
  # Create a new column for the total of collisions for the neighbourhood (2017 to 2023)
  rename(total_collisions_2017_2023 = num) |>
  ungroup()

#### Save data ####
# Save dataset 1
write_csv(dataset_1, "outputs/data/cleaned_collisions_data.csv")
# Save dataset 2
write_csv(cleaned_ward_data, "outputs/data/cleaned_ward_data.csv")
# Save dataset 3
write_csv(dataset_3, "outputs/data/cleaned_map_data.csv")
# Save dataset 4
saveRDS(cleaned_city_ward_data, "outputs/data/cleaned_city_wards.RDS")