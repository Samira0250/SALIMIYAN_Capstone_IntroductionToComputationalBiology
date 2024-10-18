# SALIMIYAN_Capstone
## Motivation 
This project is designed to filter species data based on geographic coordinates from provided CSV files. By extracting latitude and longitude information, it helps researchers analyze species' locations more effectively. This program is useful for a biodiversity research, species distribution modeling, and many other ecological data analyses where species location data are critical.

## How to Use
*Prerequisites* 
Before running the script, ensure the following:

- You have a bash shell environment.
- The input CSV files containing species data are in your working directory.
- You've created a Species_list.txt file, listing all the neccessary CSV files to initiate.
*Steps*:
Step 1:  Copy all the csv files into your working directory.
Step 2: Create a list of your species files using the following command:
" ls *.csv > Species_list.txt"
Step 3: Once your input file list is ready, run the script by using Species_list.txt as an argument:
"./SALIMIYAN_GBIF.sh Species_list.txt"
  This script will generate two important output files:
A. Filtered.txt which is a summary of each species and the percentage of records containing geographic coordinates.
B. Lat_Long_combined.txt which is a combined file with filtered geographic data for all species.

**Example Codes**
```bash
# Filter the file by removing header and selecting records with latitude/longitude
grep -E '[0-9]+\.[0-9]+' "$file" | tail -n +2 > "${species}_lat_long.txt"

# Calculate percentage of records with locality info
total_records=$(wc -l "$file" | awk '{print $1}')
locality_records=$(wc -l "${species}_lat_long.txt" | awk '{print $1}')
percent_filtered=$(echo "scale=2; ($locality_records / $total_records) * 100" | bc)
This code filters each species' file and calculates the percentage of records with valid latitude and longitude data.

| Species    | Percent Filtered |
|------------|------------------|
| castaneus  | 99.00%           |
| domesticus | 99.00%           |
| musculus   | 99.00%           |
| molossinus | 97.00%           |
| spretus    | 99.00%           |
