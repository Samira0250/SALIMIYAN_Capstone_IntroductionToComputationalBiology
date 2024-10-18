#!/bin/bash

#This script is only exacutable for one of the species from CP1, domesticus AKA DOM!

#Download the zip from Canvas, name is: GB_data.zip.
#Unzip this file by double clicking and then make a list file following the command below:

#ls *.csv > Species_list.txt
#This file will be considered as the 'input file' for the rest of the project!


# Check if the input file (species list) is provided
if [ -z "$1" ]; then
    echo "Error: No input file provided. Please provide a species list file (e.g., Species_list.txt)."
    exit 1
fi

# Check if the input file exists
if [ ! -f $1 ]; then
    echo "Error: File '$1' not found. Please provide a valid species list file."
    exit 1
fi

# Count the number of species in the input file (number of lines)
Species_count=$(wc -l < "$1")

# Print out the species count for verification
echo "Number of  in the input file: $Species_count"

#Create an empty file called 'Filtered.txt' and add a header
echo -e "Species name\tPercent filtered" > Filtered.txt

# Read each line of the input file into an array
species_files=($(cat "$1"))

# Print the contents of the array to verify
echo "Species files read from input file:"

for file in "${species_files[@]}"; do
    echo "$file"
done

# Combine all filtered records file should start empty
> Lat_Long_combined.txt 

# Loop through the species files
for file in "${species_files[@]}"; do

# Check if the species is 'domesticus' in the file
species=$(awk -F'\t' 'NR==2 {print $10, $11}' "$file" | awk '{print $NF}')
#if [[ "$species" == *"domesticus"* ]]; then
   echo "Processing species: $species from file $file"

# Filter the file by removing header and selecting records with latitude/longitude
grep -E '[0-9]+\.[0-9]+' "$file" | tail -n +2 > "${species}_lat_long.txt"

# Calculate percentage of records with locality info
  total_records=$(($(wc -l "$file" | awk '{print $1}') - 1))
  echo "$total_records"
  locality_records=$(wc -l "${species}_lat_long.txt" | awk '{print $1}')
  echo "$locality_records"
  percent_filtered=$(echo "scale=2; ($locality_records / $total_records) * 100" | bc)
  echo "$percent_filtered"

# Append results to Filtered.txt
 echo -e "$species\t$percent_filtered" >> Filtered.txt

# Combine all filtered records
 cat "${species}_lat_long.txt" >> Lat_Long_combined.txt

# Remove the temporary lat_long file after being used
        rm "${species}_lat_long.txt" 
 #  else
# echo "Skipping file $file: species not 'domesticus'."
# fi
  
    done

exit
