#### Preamble ####
# Purpose: Tests the datasets 
# Author: Emily Su
# Date: 23 January 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse has been installed by running 00-install_packages.R,
# datasets have been downloaded by running 01-download_data.R, and datasets have 
# been cleaned by running 02-data_cleaning.R


#### Workspace setup ####
library(tidyverse)

#### Read in CSV files ####
# Read in dataset 1 (Collisions Data)
dataset_1 <- read_csv("outputs/data/cleaned_collisions_data.csv")
# Read in dataset 2 (Ward Data)
dataset_2 <- read_csv("outputs/data/cleaned_ward_data.csv")
# Save dataset 3 (Map Data)
dataset_3 <- read_csv("outputs/data/cleaned_map_data.csv")

#### Test data ####

# Tests on dataset 1 (Collision Data)
# Expected Columns: year | collision_type | num_of_collisions 
# 1. "year" does not contain years before 2017 and after 2023
dataset_1$year |> min() == 2017
dataset_1$year |> max() == 2023

# 2. We have 4 types of collisions: "Personal Injury", "Fail to Remain", 
# "Property Damage", "Fatal"
dataset_1$collision_type |>
  unique() |>
  length() == 4

dataset_1$collision_type |>
  unique() %in% c("Personal Injury", "Fail to Remain", "Property Damage", "Fatal")

# 3. num_of_collisions is greater than or equal to 0.
dataset_1$num_of_collisions |> min() >= 0

# 4. Check the classes
class(dataset_1$year) == "numeric"
class(dataset_1$num_of_collisions) == "numeric"
class(dataset_1$collision_type) == "character"


# Tests on dataset 2 (Ward Data)
# Expected columns: ward_num | ward_name | pop_num | avg_income
# 1. Smallest ward number is 1 and the largest ward number is 25
dataset_2$ward_num |> min() == 1
dataset_2$ward_num |> max() == 25

# 2. There are 25 wards 
dataset_2$ward_num |>
  unique() |>
  length() == 25

dataset_2$ward_num |>
  unique() == c(1:25)

# 3. Average household income (income) is equal to or greater than 0
dataset_2$avg_income |> min() >= 0

# 4. The population is equal to or greater than 0
dataset_2$pop_num |> min() >= 0

# 5. Check classes
class(dataset_2$pop_num) == "numeric"
class(dataset_2$avg_income) == "numeric"
class(dataset_2$ward_num) == "numeric"
class(dataset_2$ward_name) == "character"

# Tests on dataset 3 (Map Data)
# Expected: year | collision_type | long | lat | neighbourhood | 
# num_of_collisions | yearly_collision_num | total_collisions_2017_2023
# 1. "year" does not contain years before 2017 and after 2023
dataset_3$year |> min() == 2017
dataset_3$year |> max() == 2023

# 2. We have 4 types of collisions: "Personal Injury", "Fail to Remain", 
# "Property Damage", "Fatal"
dataset_3$collision_type |>
  unique() |>
  length() == 4

dataset_3$collision_type |>
  unique() %in% c("Personal Injury", "Fail to Remain", "Property Damage", "Fatal")

# 3. num_of_collisions is greater than or equal to 0.
dataset_3$num_of_collisions |> min() >= 0

# 4. yearly_collision_num is greater than or equal to 0.
dataset_3$yearly_collision_num |> min() >= 0

# 5. total_collisions_2017_2023 is greater than or equal to 0.
dataset_3$total_collisions_2017_2023 |> min() >= 0

# 6. Check classes 
class(dataset_3$year) == "numeric"
class(dataset_3$collision_type) == "character"
class(dataset_3$long) == "numeric"
class(dataset_3$lat) == "numeric"
class(dataset_3$neighbourhood) == "character"
class(dataset_3$num_of_collisions) == "numeric"
class(dataset_3$yearly_collision_num) == "numeric"
class(dataset_3$total_collisions_2017_2023) == "numeric"
