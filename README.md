# SALIMIYAN_Capstone

## Motivation

This project aims to process and analyze species data through advanced filtering techniques to enhance computational efficiency and extract valuable insights. The primary objectives include refining the dataset by accurately counting records for various museums, specimen types, and citizen science contributions based on years. By implementing rigorous data filtering and analysis methods, this tool enables researchers to prioritize high-quality and relevant data. This approach facilitates more precise ecological and biodiversity studies, empowering scientists to uncover patterns, trends, and relationships within the dataset, ultimately advancing our understanding of species distribution and conservation.

## How to Use (For Shell environment)

## *Prerequisites*
Before running the script, ensure you have the following:

- A bash shell environment.
- The input CSV files containing species data are in your working directory.
- The list of species files is created in `Species_list.txt`.

### *Steps*

**Step 1: Prepare the files:** Copy all the species data CSV files into your working directory.

**Step 2: Create the species list:** Generate the species list file using the following command: 
```bash
ls *.csv > Species_list.txt
Step 3: Run the script: Once your input file list is ready, run the script by using Species_list.txt as an argument:

./SALIMIYAN_Capstone_3.sh Species_list.txt
Note: Because 0018130-240906103802322.csv has a different separator, remember to use the right awk command (see below)! The OFS (Output Field Separator) command is used in awk to define the character or string that separates fields in the output. By default, awk uses a space or tab as the field separator.

This will generate four important output files:

museum_count.txt: A table counting the number of records per museum.
specimen_count.txt: A table counting the number of records per specimen type.
citizen_count_per_year.txt: A table showing citizen science record counts (iNaturalist) by year.
museum_count_filtered.txt: A table counting records per museum, filtered by latitude and longitude.
Example Code
Here's a look at the code used to generate the tables:
```
# Process each species file and count records for each museum
for file in "${SPECIES_LIST[@]}"; do
    row="$file"
    for museum in "${MUSEUMS[@]}"; do
        count=$(awk -F'\t' -v museum="$museum" '$37 == museum {count++} END {print count+0}' "$file")
        row="$row\t$count"
    done
    echo -e "$row" >> museum_count.txt
done
This code counts records for each museum and stores the counts in museum_count.txt.

## Example Output (museum_count.txt):

|File                          |AMNH   | FMNH   |iNaturalist |  KU   |  MVZ | NHMUK |NMR | SMF |USNM |YPM  |
|------------------------------|-------|--------|------------|-------|------|-------|----|-----|-----|-----|
|0018126-240906103802322.csv   |  76   |   180  |   7        |  4    |  56  |   15  | 1  |  0  | 1321|  0  |
|0018129-240906103802322.csv   |   0   |    0   |   0        |  0    |   0  |    0  |  9 |  0  |  0  | 193 |
|0018130-240906103802322.csv   | 2090  |  2178  |   4939     |  977  | 11361|  3240 | 48 | 2086| 6459| 244 |
|0018131-240906103802322.csv   |  12   |    1   |   0        |  10   |   16 |    2  |  0 |  0  |   0 |  0  |
|0021864-240906103802322.csv   |   0   |    3   |   33       |   0   | 211  |   78  |  0 |  63 | 536 |  3  |
```

```
## How to Use (For R Environment)
## *Prerequisites*
Before running the R scripts, ensure you have the following:

R and RStudio installed on your system.
Required R packages: dplyr, tidyr, and readr. If not installed, use install.packages() to install them.

Input data files (0018126-240906103802322.csv, 0018129-240906103802322.csv, 0018130-240906103802322.csv, 0018131-240906103802322.csv, 0021864-240906103802322.csv) in your working directory. The list of input files is named Lat_Long_combined.

*Steps*
## Step 1: Prepare the Files
Place all the required input CSV files in your working directory.
Ensure the files are named correctly as provided above.

## Step 2: Set Up the R Environment
Open RStudio and set your working directory to the folder containing the input files:

setwd("C:/Users/szs0394/Downloads/CP4")

## Step 3: Run Part A (Mapping)
Open the script file SALIMIYAN_CP4_PartA.R.
Execute the script to generate a high-quality map (SALIMIYAN_MapA.png).

The script will:

Process the combined dataset (Lat_Long_combined.txt) to extract and clean species-specific geographical data.
Plot the range map with distinct colors and markers for each species.

## Step 4: Run Part B (Tables)
Open the script file SALIMIYAN_CP4_PartB.R.
Execute the script to generate four output tables:

museum_count.csv: Counts records for each museum across species.
specimen_count.csv: Counts records for each specimen type across species.
citizen_count_per_year.csv: Counts citizen science (iNaturalist) records annually.
museum_count_filtered.csv: Counts museum records filtered by valid latitude and longitude.

## Example output (citizen_count_per_year.csv):

| year  |	n |
|-------|-----|
| 1980	| 1   |
| 1985	| 1   |
| 2003	| 2   |
| 2004	| 5   |
| 2005	| 7   |
| 2006	| 10  |
| 2007	| 11  |
| 2008	| 10  |
| 2009	| 13  |
| 2010	| 10  |
| 2011	| 13  |
| 2012	| 16  |
| 2013	| 52  | 
| 2014	| 73  |
| 2015	| 92  |
| 2016	| 166 |
| 2017	| 199 |
| 2018	| 291 |
| 2019	| 393 |
| 2020	| 565 |
| 2021	| 593 |
| 2022	| 735 | 
| 2023	| 895 |
| 2024	| 537 |

## Key Features:
Handles discrepancies in column structures between files using cleaning steps.
Per Dr. Stevison's guidance, special handling for the 0018130-240906103802322.csv file required read_delim() for compatibility.

*Challenges and Solutions*

1. Handling Inconsistent Data Formats:
The script leverages custom column cleaning steps to remove leading/trailing spaces, assign meaningful column names, and handle missing data efficiently.

2. Special Case Handling: The Mus musculus dataset had unique format challenges, so the read_delim() function was used with dynamic column name generation.
3. Error Checking: Each script checks for file existence and missing columns, providing meaningful warnings when issues are encountered.
4. Output Validation: Final tables are carefully inspected to ensure alignment with expected formats (e.g., no NA columns, consistent headers).

*Acknowledgement*
- CP3 Key
- Special handling instruction by Dr. Stevison for the Mus musculus musculus file.
  
**Friendly Reminder**
## If you use this script in your research, please cite it as:
"SALIMIYAN_Capstone, GitHub Repository."

**Thanks, and good luck with your analysis!**
