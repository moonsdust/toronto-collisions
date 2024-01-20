#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto 
# on traffic collisions and information about the Toronto wards.  
# Author: Emily Su
# Date: 25 January 2024
# Contact: em.su@mail.utoronto.ca
# License: MIT
# Pre-requisites: opendatatoronto and tidyverse has been installed 
# by running 00-install_packages.R

# Datasets that will be downloaded and saved:
# 1. Police Annual Statistical Report - Traffic Collisions: https://open.toronto.ca/dataset/police-annual-statistical-report-traffic-collisions/
# 2. City Wards - Traffic Collisions: https://open.toronto.ca/dataset/city-wards/
# 3. Ward Profiles (25-Ward Model): https://open.toronto.ca/dataset/ward-profiles-25-ward-model/

#### Workspace setup ####
# Loading packages
library(opendatatoronto)
library(tidyverse)

#### Download data ####



#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(the_raw_data, "inputs/data/raw_data.csv") 

         
