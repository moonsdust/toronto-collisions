#### Preamble ####
# Purpose: To simulate datasets regarding motor vehicle collisions 
# across Toronto 
# Author: Emily Su
# Date: 25 January 2024
# Contact: em.su@utoronto.ca
# License: MIT
# Pre-requisites: tidyverse and knitr have been installed, else 
# uncomment the code to install the two packages.

#### Workspace setup #### 

## Installing packages (only needs to be done once per computer)
# Uncomment the below if this is the first time running the script 
# install.packages("tidyverse")
# install.packages("knitr")
library(tidyverse) # Contains data-related packages
library(knitr) # To make tables

#### Simulate data ####
set.seed(646)

### Global Variables ###
number_of_years <- 7 
num_of_wards <- 25 # Number of wards in Toronto
toronto_pop <- 2930000 # Population of Toronto

## Dataset 1: Simulate dataset regarding the number of collisions, 
# collision types, and what year the collision occured ##
# Expected Columns: year | collision_type | num_of_collisions 
simulated_data_one <-
  tibble(
    # We will repeat the type of collision name for <number_of_years> times 
    collision_type =
      c(rep("Personal Injury", number_of_years), 
        rep("Fail to Remain", number_of_years), 
        rep("Property Damage", number_of_years), 
        rep("Fatal", number_of_years)),
    # We will create a vector for the years 2017 to 2023
    # and repeat this 4 times for each type of collision 
    year = rep(c(1:number_of_years + 2016), 4),
    # We will create <number_of_years> * 4 random values 
    # from a uniform distribution to get the number of collisions 
    # each year for each collision type 
    num_of_collisions =
      round(runif(n = number_of_years * 4, min = 0, max = 1000))
  )
# Creates table for the simulated data
simulated_data_one

# Dataset 1: Data Validation / Tests
# 1. "year" does not contain years before 2017 and after 2023
simulated_data_one$year |> min() == 2017
simulated_data_one$year |> max() == 2023

# 2. We have 4 types of collisions: "Personal Injury", "Fail to Remain", 
# "Property Damage", "Fatal"
simulated_data_one$collision_type |>
  unique() |>
  length() == 4

simulated_data_one$collision_type |>
  unique() == c("Personal Injury", "Fail to Remain", "Property Damage", "Fatal")

# 3. num_of_collisions is greater than or equal to 0.
simulated_data_one$num_of_collisions |> min() >= 0



## Dataset 2 and 3: Simulate dataset regarding the ward number, 
# number of collisions, average household income of each ward,
# population of each ward ##
# Expected Columns: ward_num | num_of_collisions | income | pop_num
simulated_data_two_three <-
  tibble(
    ward_num = c(1:num_of_wards),
    num_of_collisions = sample(x = 0:1000, size = num_of_wards, replace = TRUE),
    income = sample(x = 0:100000, size = num_of_wards, replace = TRUE),
    pop_num = sample(x = 0:toronto_pop / num_of_wards, size = num_of_wards, replace = TRUE)
  )
# Creates table for the simulated data
simulated_data_two_three

# Dataset 2 and 3: Data Validation / Tests
# 1. Smallest ward number is 1 and the largest ward number is 25
simulated_data_two_three$ward_num |> min() == 1
simulated_data_two_three$ward_num |> max() == 25

# 2. There are 25 wards 
simulated_data_two_three$ward_num |>
  unique() |>
  length() == 25

simulated_data_two_three$ward_num |>
  unique() == c(1:25)

# 3. Number of collisions is equal to or greater than 0
simulated_data_two_three$num_of_collisions |> min() >= 0

# 4. Average household income (income) is equal to or greater than 0
simulated_data_two_three$income |> min() >= 0

# 5. The population is equal to or greater than 0
simulated_data_two_three$pop_num |> min() >= 0