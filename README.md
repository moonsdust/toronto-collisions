# Toronto Collisions

## Overview
As one of the fastest growing cities and densest cities in Canada, road andpedestarian safety are growing concerns in Toronto, espically after the COVID-19Pandemic. This paper looks at trends of collisions from 2017 to 2023 in Torontoneighbourhoods and wards, types of collisions, and the number of pedestriansinvolved. The results shows that motor vehicle collisions and pedestarian involve-ment in them have decreased after the pandemic. However, further investigationis needed on the demographics of Toronto areas with high number of motor vehiclecollisions.

This repository is associated with the paper, "Motor Vehicle Collisions Reduced AcrossToronto During and After the Beginning of the COVID-19 Pandemic" by Emily Su. 

## Important Notes
**About unedited_collisions_data.csv**: This CSV file is currently not in `inputs/data`
due to its file size exceeding 100MB. To download `unedited_collisions_data.csv`, 
run the script `01-download_data.R` located in the following path: `scripts/01-download_data.R`. 

**Statement on LLM usage: No LLMs were used for any aspect of this work.**

## File Structure

The repo is structured as:

-   `input/data` contains the data sources used in analysis including the raw data.
-   `outputs/data` contains the cleaned dataset that was constructed.
-   `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.