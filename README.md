# Motor Vehicle Collisions Decreased in Toronto During and After the Beginning of the COVID-19 Pandemic

## Overview
As one of the fastest-growing and densest Canadian cities, road and pedestrian safety are growing concerns in Toronto, especially after the COVID-19 pandemic. This paper looks at trends of motor vehicle collisions from 2017 to 2023 in Toronto neighbourhoods and wards, types of collisions, and the number of pedestrians involved. The results show that motor vehicle collisions and pedestrian involvement in them have decreased during and after the pandemic but are prevalent in the same areas from 2017 to 2023. Further investigation is needed on the demographics of Toronto areas with a high number of motor vehicle collisions.

This repository is associated with the paper, "Motor Vehicle Collisions Decreased in Toronto During and After the Beginning of the COVID-19 Pandemic". 

## Important Note
**About unedited_collisions_data.csv**: This CSV file is currently not in `inputs/data`
due to its file size exceeding 100MB. To download `unedited_collisions_data.csv`, 
run the script `01-download_data.R` located in the following path: `scripts/01-download_data.R`. 

**Statement on LLM usage: No LLMs were used for any aspect of this work.**

## File Structure

The repo is structured as:

-   `input/data` contains the data sources used in analysis including the raw data.
-   `input/sketches` contains the sketches made when planning out how the dataset should look and the resulting graphs.
-   `outputs/data` contains the cleaned dataset that was constructed.
-   `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.