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

#### Clean data ####

## Read in datasets ##
raw_collisions_data <- read_csv("inputs/data/unedited_collisions_data.csv", show_col_types = FALSE)
raw_ward_profiles_data <- read_csv("inputs/data/unedited_ward_profiles_data.csv", show_col_types = FALSE)

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
    lat_wgs84
  )

# Renaming occ_year column to year
cleaned_collisions_data <-
  cleaned_collisions_data |>
  rename( # Left side is the new name and the right side is the old name
    year = occ_year
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

# Convert columns from character to numeric
cleaned_collisions_data$injury_collisions <- as.numeric(cleaned_collisions_data$injury_collisions)
cleaned_collisions_data$pd_collisions <- as.numeric(cleaned_collisions_data$pd_collisions)
cleaned_collisions_data$ftr_collisions <- as.numeric(cleaned_collisions_data$ftr_collisions)


# Dataset 1 (number of collisions, collision types, and what year the collision occurred)
# Expected Columns: year | collision_type | num_of_collisions 
# Create a new dataset
dataset_1 <-
  cleaned_collisions_data |>
  select(-c(long_wgs84,lat_wgs84)) |>
  group_by(year, fatalities, injury_collisions, pd_collisions, ftr_collisions) |>
  mutate(num = n()) |> # count number of rows based on premise and year
  rename(num_of_collisions = num) |>
  unique() |> # This will filter out repeated rows  
  filter(
    (fatalities == 1 && injury_collisions == 0 && pd_collisions == 0 && ftr_collisions == 0) |
      (fatalities == 0 && injury_collisions == 1 && pd_collisions == 0 && ftr_collisions == 0) |
      (fatalities == 0 && injury_collisions == 0 && pd_collisions == 1 && ftr_collisions == 0) |
      (fatalities == 0 && injury_collisions == 0 && pd_collisions == 0 && ftr_collisions == 1)
    ) # Only include rows that is 1 in only one of the 4 columns 

# Add a new column collision_type by matching current columns to be values of this new column, 
# Remove the columns `fatalities`, `injury_collisions`, `pd_collisions`, `ftr_collisions`, and
# Rearrange columns 
dataset_1 <- 
  dataset_1 |>
  mutate( 
    collision_type = 
      case_when( #  
      (fatalities == 1 && injury_collisions == 0 && pd_collisions == 0 && ftr_collisions == 0) ~ "Fatal",
      (fatalities == 0 && injury_collisions == 1 && pd_collisions == 0 && ftr_collisions == 0) ~ "Personal Injury", 
      (fatalities == 0 && injury_collisions == 0 && pd_collisions == 1 && ftr_collisions == 0) ~ "Property Damage", 
      (fatalities == 0 && injury_collisions == 0 && pd_collisions == 0 && ftr_collisions == 1) ~ "Fail to Remain", 
      TRUE ~ "None"
      )
    ) |>
  ungroup() |>
  select(-c(fatalities, injury_collisions, pd_collisions, ftr_collisions)) |> # Remove columns
  select(year, collision_type, num_of_collisions) # Rearrange columns in desired order  


# Dataset 2 (cleaned_ward_data)
# Expected columns: ward_num | pop_num | avg_income
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
    ward_num = c(1:25)
  )

# Get row that contains the average household income
ward_avg_income_row <- 
  cleaned_ward_data |> 
  filter(x2021_one_variable_city_of_toronto_profiles == "Average total income of households in 2020 ($)")
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
    ward_num = c(1:25)
  )

# Convert columns from character to numeric
ward_avg_income$avg_income <- as.numeric(ward_avg_income$avg_income)
ward_pop_size$pop_num <- as.numeric(ward_pop_size$pop_num)

# Join ward_pop_size, and ward_avg_income_row into a single tibble 
cleaned_ward_data <- 
  ward_pop_size |>
  right_join(ward_avg_income, by = "ward_num")


# Dataset 3 (Contains data of collision type and their longitude and latitude)
# Expected: collision_type | long | lat
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
  select(-c(year, fatalities, injury_collisions, pd_collisions, ftr_collisions)) |> # Remove columns
  select(collision_type, long_wgs84, lat_wgs84) |> # Rearrange columns in desired order  
  rename ( # Left side is the new name and the right side is the old name
    long = long_wgs84,
    lat = lat_wgs84
  )

#### Save data ####
# Save dataset 1
write_csv(dataset_1, "outputs/data/cleaned_collisions_data.csv")
# Save dataset 2
write_csv(cleaned_ward_data, "outputs/data/cleaned_ward_data.csv")
# Save dataset 3
write_csv(dataset_3, "outputs/data/cleaned_map_data.csv")