#!/bin/bash


    # Moving into speices directory
    cd $species

    # Putting the correct dataset in the correct subdirectory
    cp ../${files[$i]} .

    # Copying header into new file, removing the header, checking to make sure it worked
    head -1 ${files[$i]} > ${species}_header.txt
    tail -n+2 ${files[$i]} >${species}.txt

    tot=`wc -l ${species}.txt | awk '{print $1}'`
    echo "Total: $tot"

    # Sorting the file by latitude, using a one-liner
    sort -k22 ${species}.txt | uniq > ${species}_lat_uniq.txt

    # Sorting the previous file by longitude, using a one-liner
    sort -k23 ${species}_lat_uniq.txt |uniq > ${species}_lat_long_uniq.txt

    # Getting columns (fields) 17 and 18, which should be lat and long using a tab as the field-separator (\t)
    awk 'FS="\t" {print $22, $23}' ${species}_lat_long_uniq.txt >${species}_lat_long.txt

    # Grabbing only records that DO NOT (-v) begin (^)with a space (\s), repeated zero or more times (*), until the end of the line ($) [A blank line!]
    grep -v "^\s*$" ${species}_lat_long.txt > ${species}_lat_long_cleaned.txt

    # Counting number of lines in original and filtered files
    filt=`wc -l ${species}_lat_long_cleaned.txt | awk '{print $1}'`
    echo Filtered: $filt

    # Using BC calculator (use man bc for syntax and options) to determine percent duplicated records
    peruni=`echo "scale=4; ($filt/$tot)* 100"| bc`

    echo "Percent with locality records: $peruni %"

    echo "$species\t$peruni" >>../Filtered.txt

    #remove intermediate files
    rm ${files[$i]} ${species}_header.txt ${species}.txt ${species}_lat_uniq.txt ${species}_lat_long_uniq.txt ${species}_lat_long.txt

    #move back into the home directory
    cd ../

done
#loop ends here
# Moving to the main directory to make concatenated lat,long files
cat ./*/*_lat_long_cleaned.txt > Lat_Long_combined.txt


# Script to refine and analyze museum dataset records with specified requirements

# Define paths and constants
SPECIES_LIST=("0018126-240906103802322.csv" "0018129-240906103802322.csv" "0018130-240906103802322.csv" "0018131-240906103802322.csv" "0021864-240906103802322.csv")
MUSEUMS=("AMNH" "FMNH" "iNaturalist" "KU" "MVZ" "NHMUK" "NMR" "SMF" "USNM" "YPM")
SPECIMEN_TYPES=("PRESERVED_SPECIMEN" "HUMAN_OBSERVATION" "OCCURRENCE" "MATERIAL_SAMPLE")

# Refine the Script for Efficiency
for file in "${SPECIES_LIST[@]}"; do
    # Check if file exists and is not empty
    if [[ -s "$file" ]]; then
        echo "Processing file: $file"

        # Set output file name with species name added to each line
        species_name=""
        case $file in
            "0018126-240906103802322.csv") species_name="Mus musculus castaneus";;
            "0018129-240906103802322.csv") species_name="Mus musculus domesticus";;
            "0018130-240906103802322.csv") species_name="Mus musculus OR Mus musculus musculus";;
            "0018131-240906103802322.csv") species_name="Mus musculus molossinus";;
            "0021864-240906103802322.csv") species_name="Mus spretus spp.";;
        esac

        # Filter for species and add species column in the output
        awk -F'\t' -v species="$species_name" '{if($10 ~ /Mus/) print $22, $23, species}' "$file" > filtered_$file
    else
        echo "Warning: $file does not exist or is empty."
    fi
done

# Count records for each museum and store them in a table
# Find the right column for institutional code, record column ,... using this: head -n 1 0018126-240906103802322.csv | awk -F'\t' '{for (i=1; i<=NF; i++) print i, $i}'
echo -e "File\t${MUSEUMS[*]}" > museum_count.txt
for file in "${SPECIES_LIST[@]}"; do
    row="$file"
    for museum in "${MUSEUMS[@]}"; do
        count=$(awk -F'\t' -v museum="$museum" '$37 == museum {count++} END {print count+0}' "$file")
        row="$row\t$count"
    done
    echo -e "$row" >> museum_count.txt
done

# Count records for each specimen type and store them in a table
echo -e "File\t${SPECIMEN_TYPES[*]}" > specimen_count.txt
for file in "${SPECIES_LIST[@]}"; do
    row="$file"
    for specimen in "${SPECIMEN_TYPES[@]}"; do
        count=$(awk -F'\t' -v specimen="$specimen" '$36 == specimen {count++} END {print count+0}' "$file")
        row="$row\t$count"
    done

    # Analyze citizen science records by year for Mus musculus musculus (from iNaturalist)

OFS="\t"
file="0018130-240906103802322.csv"
output_file="citizen_count_per_year.txt"

# Clear the output file to avoid appending multiple times
echo -e "Year\tCount" > "$output_file"

# Loop through each unique year found in the dataset
for year in $(awk -F'\t' '$37 == "iNaturalist" {print $33}' "$file" | sort -u); do
    # Count occurrences of each year for iNaturalist records
    count=$(awk -F'\t' -v year="$year" '$37 == "iNaturalist" && $33 == year {count++} END {print count+0}' "$file")

    # Output the year and count to the output file, separated by a tab
    echo -e "$year$OFS$count" >> "$output_file"
done

# Confirmation message
echo "Table of year counts for iNaturalist records saved to $output_file"

# Check the contents of the output file
cat citizen_count_per_year.txt

# Filtered Museum Counts for Records with Latitude/Longitude
echo -e "File\t${MUSEUMS[*]}" > museum_count_filtered.txt
for file in "${SPECIES_LIST[@]}"; do
    row="$file"
    for museum in "${MUSEUMS[@]}"; do
        count=$(awk -F'\t' -v museum="$museum" '($37 == museum && $22 && $23) {count++} END {print count+0}' "$file")
        row="$row\t$count"
    done
    echo -e "$row" >> museum_count_filtered.txt
done

# Save the tables to files as specified
cp museum_count.txt specimen_count.txt citizen_count_per_year.txt museum_count_filtered.txt ~/CP3/Output
echo "Tables have been saved to the output directory."
