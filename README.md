# SALIMIYAN_Capstone
## Motivation 
This project is designed to filter species data based on geographic coordinates from provided CSV files. Extracting latitude and longitude information helps researchers analyze species' locations more effectively. This program is useful for biodiversity research, species distribution modeling, and many other ecological data analyses where species location data are critical.

## How to Use
*Prerequisites* 
Before running the script, ensure the following:

- You have a bash shell environment.
  
- The input CSV files containing species data are in your working directory.
  
- You've created a Species_list.txt file, listing all the necessary CSV files to initiate.

*Steps*:

Step 1:  Copy all the CSV files into your working directory.

Step 2: Create a list of your species files using the following command:

" ls *.csv > Species_list.txt"

Step 3: Once your input file list is ready, run the script by using Species_list.txt as an argument:

"./SALIMIYAN_GBIF.sh Species_list.txt"

  This script will generate two important output files:

      A. Filtered.txt which is a summary of each species and the percentage of records containing geographic coordinates.
      B. Lat_Long_combined.txt is a combined file with filtered geographic data for all species.

**Example Codes**
```bash
# Check if the input file (species list) is provided
if [ -z "$1" ]; then
    echo "Error: No input file provided. Please provide a species list file (e.g., Spe$
    exit 1
fi

# Check if the input file exists
if [ ! -f $1 ]; then
    echo "Error: File '$1' not found. Please provide a valid species list file."
    exit 1
fi
# Filter the file by removing the header and selecting records with latitude/longitude
grep -E '[0-9]+\.[0-9]+' "$file" | tail -n +2 > "${species}_lat_long.txt"

# Calculate the percentage of records with locality info
total_records=$(wc -l "$file" | awk '{print $1}')
locality_records=$(wc -l "${species}_lat_long.txt" | awk '{print $1}')
percent_filtered=$(echo "scale=2; ($locality_records / $total_records) * 100" | bc)
This code filters each species' file and calculates the percentage of records with valid latitude and longitude data.

# Remove the temporary lat_long file after being used IN THE LOOP! Otherwise, this file will grow each time you run the program!
 rm "${species}_lat_long.txt"

| Species    | Percent Filtered |
|------------|------------------|
| castaneus  | 99.00%           |
| domesticus | 99.00%           |
| musculus   | 99.00%           |
| molossinus | 97.00%           |
| spretus    | 99.00%           |
```
## How to Cite

If you use this script in your research, please cite it as:
"SALIMIYAN_Capstone, GitHub Repository."

**Thank You!** 
