#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto 
# on traffic collisions and information about the Toronto wards.  
# Author: Emily Su
# Date: 23 January 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: opendatatoronto and tidyverse has been installed 
# by running 00-install_packages.R
# IMPORTANT NOTE: The "Police Annual Statistical Report - Traffic Collisions" dataset, 
# is a large file so it might take a while to finish downloading and saving the file. 

# Datasets that will be downloaded and saved:
# 1. Ward Profiles (25-Ward Model): https://open.toronto.ca/dataset/ward-profiles-25-ward-model/
# 2. City Wards - Traffic Collisions: https://open.toronto.ca/dataset/city-wards/
# 3. Police Annual Statistical Report - Traffic Collisions: https://open.toronto.ca/dataset/police-annual-statistical-report-traffic-collisions/

#### Workspace setup ####
# Loading packages
library(opendatatoronto)
library(tidyverse)


#### Download and Save data ####
# Code snippet to filter for and download datasets was adapted from: 
# https://open.toronto.ca/dataset/police-annual-statistical-report-traffic-collisions/

# Function to download files
download_csv_geojson <- function(files) {
  filter(files, row_number()==1) |> get_resource()
}

# Download "Ward Profiles (25-Ward Model)" dataset
ward_profiles_data <- download_csv_geojson(list_package_resources("6678e1a6-d25f-4dff-b2b7-aa8f042bc2eb"))
# Save "Ward Profiles (25-Ward Model)" dataset
write_csv(as.data.frame(ward_profiles_data[1]), "inputs/data/unedited_ward_profiles_data.csv")

# Download "City Wards" dataset
# Filter for CSV and geojson files in the package resources list
files_one <- filter(list_package_resources("5e7a8234-f805-43ac-820f-03d7c360b588"), tolower(format) %in% c('csv', 'geojson'))
city_wards_data <- download_csv_geojson(files_one)
# Save "City Wards" dataset as a R object 
# Code snippet adapted from https://fcostartistician.wordpress.com/2017/09/13/how-to-deal-with-spatial-data-in-r-and-ggplot-shapefiles/ 
saveRDS(city_wards_data, 'inputs/data/city_wards.RDS')

# Download "Police Annual Statistical Report - Traffic Collisions" dataset
# Filter for CSV and geojson files in the package resources list
files_two <- filter(list_package_resources("ec53f7b2-769b-4914-91fe-a37ee27a90b3"), tolower(format) %in% c('csv'))
collisions_data <- download_csv_geojson(files_two)
# Save "Police Annual Statistical Report - Traffic Collisions" dataset
write_csv(collisions_data, "inputs/data/unedited_collisions_data.csv")