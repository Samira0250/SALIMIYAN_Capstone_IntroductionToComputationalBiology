#CP4--Part B
#Install and load required libraries
install.packages("dplyr")
install.packages("tidyr")

library(dplyr)
library(tidyr)

# Set the working directory
setwd("")

#Table for specimen_count
# Define the file list and species names
species_list <- c("0018126-240906103802322.csv", "0018129-240906103802322.csv", 
                  "0018130-240906103802322.csv", "0018131-240906103802322.csv", 
                  "0021864-240906103802322.csv")

species_names <- c("Mus musculus castaneus", "Mus musculus domesticus", 
                   "Mus musculus musculus", "Mus musculus molossinus", 
                   "Mus spretus")

specimen_types <- c("PRESERVED_SPECIMEN", "HUMAN_OBSERVATION", "OCCURRENCE", "MATERIAL_SAMPLE")

# Initialize a dataframe to store results
specimen_count <- tibble(File = character(), PRESERVED_SPECIMEN = integer(), 
                         HUMAN_OBSERVATION = integer(), OCCURRENCE = integer(), 
                         MATERIAL_SAMPLE = integer())

# Loop through each file in the species list
for (i in seq_along(species_list)) {
  
  file_name <- species_list[i]
  species_name <- species_names[i]  # Map the file to its species name
  
  # Check if the file exists before reading
  if (file.exists(file_name)) {
    
    # Read the file
    data <- read.delim(file_name, sep = "\t", header = TRUE)
    
    # Count records for each specimen type
    specimen_tbl <- data %>%
      count(basisOfRecord) %>%
      complete(basisOfRecord = specimen_types, fill = list(n = 0)) %>%
      pivot_wider(names_from = basisOfRecord, values_from = n, values_fill = 0) %>%
      mutate(File = species_name) %>%  # Use species_name instead of file_name
      select(File, all_of(specimen_types))  # Ensure column order matches
    
    # Bind the result to the main table
    specimen_count <- bind_rows(specimen_count, specimen_tbl)
    
  } else {
    warning(paste("File", file_name, "does not exist. Skipping."))
  }
}

# Write the final table to a file
write.table(specimen_count, "specimen_count.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Print completion message
cat("Specimen count table has been successfully generated and saved to 'specimen_count.txt'!\n")

# Table for museum_count
# Load necessary libraries
library(dplyr)
library(tidyr)

# Define the file list and species names
species_list <- c("0018126-240906103802322.csv", "0018129-240906103802322.csv", 
                  "0018130-240906103802322.csv", "0018131-240906103802322.csv", 
                  "0021864-240906103802322.csv")

species_names <- c("Mus musculus castaneus", "Mus musculus domesticus", 
                   "Mus musculus musculus", "Mus musculus molossinus", 
                   "Mus spretus")

# Define the list of museums
museums <- c("AMNH", "FMNH", "iNaturalist", "KU", "MVZ", "NHMUK", "NMR", "SMF", "USNM", "YPM")

# Initialize a dataframe to store results for museum count
museum_count <- tibble(File = character(), AMNH = integer(), FMNH = integer(), 
                       iNaturalist = integer(), KU = integer(), MVZ = integer(), 
                       NHMUK = integer(), NMR = integer(), SMF = integer(), USNM = integer(), YPM = integer())

# Loop through each file in the species list
for (i in seq_along(species_list)) {
  
  file_name <- species_list[i]
  species_name <- species_names[i]  # Get species name from the list
  
  # Check if the file exists before reading
  if (file.exists(file_name)) {
    
    # Read the file
    data <- read.delim(file_name, sep = "\t", header = TRUE)
    
    # Clean column names by removing any leading/trailing spaces or empty strings
    colnames(data) <- gsub("^\\s+|\\s+$", "", colnames(data))  # Remove leading/trailing spaces
    colnames(data) <- make.names(colnames(data), unique = TRUE)  # Ensure column names are unique
    
    # Check for any empty column names and replace them
    colnames(data)[colnames(data) == ""] <- "empty_column"
    
    # Initialize a row to store counts for the current species
    row <- c(species_name)  # Start the row with the species name
    
    # Loop through each museum and count occurrences
    for (museum in museums) {
      count <- sum(data$institutionCode == museum, na.rm = TRUE)  # Count records for the current museum
      row <- c(row, count)  # Add the count for the current museum
    }
    
    # Append the row to the final data frame
    museum_count <- bind_rows(museum_count, as.data.frame(t(row), stringsAsFactors = FALSE))
    
  } else {
    warning(paste("File", file_name, "does not exist. Skipping."))
  }
}

# Remove extra columns from the final data frame (if any)
museum_count <- museum_count[, colSums(is.na(museum_count)) < nrow(museum_count)]

# Set column names for the final data frame
colnames(museum_count) <- c("File", museums)  # Update column names

# Remove any rows where all values are NA
museum_count <- museum_count %>%
  filter(!if_all(everything(), is.na))

# Write the final table to a file
write.table(museum_count, "museum_count.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Print completion message
cat("Museum count table has been successfully generated and saved to 'museum_count.txt'!\n")

#Table for citizen_count_per_year
# Load necessary libraries
library(dplyr)

# Define the species file and output file
species_file <- "0018130-240906103802322.csv"
output_file <- "citizen_count_per_year.txt"

# Read the dataset
data <- read.delim(species_file, sep = "\t", header = TRUE)

# Filter the data to only include iNaturalist records
citizen_data <- data %>%
  filter(institutionCode == "iNaturalist")

# Count occurrences by year
citizen_count <- citizen_data %>%
  count(year) %>%
  arrange(year)

# Write the result to the output file (table format)
write.table(citizen_count, output_file, sep = "\t", row.names = FALSE, quote = FALSE)

# Confirmation message
cat("Table of year counts for iNaturalist records saved to", output_file, "\n")

# Check the contents of the output file (optional)
cat(readLines(output_file), sep = "\n")


# Table for museum_count_filtered
# Load necessary libraries
library(dplyr)
library(tidyr)

# Define the file list and species names
species_list <- c("0018126-240906103802322.csv", "0018129-240906103802322.csv", 
                  "0018130-240906103802322.csv", "0018131-240906103802322.csv", 
                  "0021864-240906103802322.csv")

species_names <- c("Mus musculus castaneus", "Mus musculus domesticus", 
                   "Mus musculus musculus", "Mus musculus molossinus", 
                   "Mus spretus")

# Define the list of museums
museums <- c("AMNH", "FMNH", "iNaturalist", "KU", "MVZ", "NHMUK", "NMR", "SMF", "USNM", "YPM")

# Initialize a dataframe to store results for museum count filtered
museum_count_filtered <- tibble(File = character(), AMNH = integer(), FMNH = integer(), 
                                iNaturalist = integer(), KU = integer(), MVZ = integer(), 
                                NHMUK = integer(), NMR = integer(), SMF = integer(), USNM = integer(), YPM = integer())

# Loop through each file in the species list
for (i in seq_along(species_list)) {
  
  file_name <- species_list[i]
  species_name <- species_names[i]  # Get species name from the list
  
  # Check if the file exists before reading
  if (file.exists(file_name)) {
    
    # Read the file
    data <- read.delim(file_name, sep = "\t", header = TRUE)
    
    # Clean column names by removing any leading/trailing spaces or empty strings
    colnames(data) <- gsub("^\\s+|\\s+$", "", colnames(data))  # Remove leading/trailing spaces
    colnames(data) <- make.names(colnames(data), unique = TRUE)  # Ensure column names are unique
    
    # Check for any empty column names and replace them
    colnames(data)[colnames(data) == ""] <- "empty_column"
    
    # Filter the data to only include rows with non-NA latitude and longitude
    filtered_data <- data %>%
      filter(!is.na(decimalLatitude) & !is.na(decimalLongitude))
    
    # Initialize a row to store counts for the current species
    row <- c(species_name)  # Start the row with the species name
    
    # Loop through each museum and count occurrences
    for (museum in museums) {
      count <- sum(filtered_data$institutionCode == museum, na.rm = TRUE)  # Count records for the current museum
      row <- c(row, count)  # Add the count for the current museum
    }
    
    # Append the row to the final data frame
    museum_count_filtered <- bind_rows(museum_count_filtered, as.data.frame(t(row), stringsAsFactors = FALSE))
    
  } else {
    warning(paste("File", file_name, "does not exist. Skipping."))
  }
}

# Remove extra columns from the final data frame (if any)
museum_count_filtered <- museum_count_filtered[, colSums(is.na(museum_count_filtered)) < nrow(museum_count_filtered)]

# Set column names for the final data frame
colnames(museum_count_filtered) <- c("File", museums)  # Update column names

# Remove any rows where all values are NA
museum_count_filtered <- museum_count_filtered %>%
  filter(!if_all(everything(), is.na))

# Write the final table to a file
write.table(museum_count_filtered, "museum_count_filtered.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Print completion message
cat("Filtered museum count table has been successfully generated and saved to 'museum_count_filtered.txt'!\n")

#Part C: Create the CSV extension of the table files
# Write Specimen Count Table
write.table(specimen_count, "specimen_count.csv", sep = ",", row.names = FALSE, quote = FALSE, col.names = TRUE)

# Write Museum Count Table
write.table(museum_count, "museum_count.csv", sep = ",", row.names = FALSE, quote = FALSE, col.names = TRUE)

# Write Citizen Count Per Year Table
write.table(citizen_count, "citizen_count_per_year.csv", sep = ",", row.names = FALSE, quote = FALSE, col.names = TRUE)

# Write Filtered Museum Count Table
write.table(museum_count_filtered, "museum_count_filtered.csv", sep = ",", row.names = FALSE, quote = FALSE, col.names = TRUE)

