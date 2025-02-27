#CP4--Part A
# Install the required packages
install.packages("maps")
install.packages("readr")

#Load the packages
library(maps)
library(readr)

# Set working directory (adjust to your folder path)
setwd("C:/Users/szs0394/Downloads/CP4/PartA")

# Read the dataset
latlong_data <- read.table("Lat_Long_combined.txt", header = TRUE, sep = "\t")

# Assign column names based on dataset structure
colnames(latlong_data) <- c("Latitude", "Longitude", "Species")  # Flipping the order of Latitude and Longitude

# Define unique species names
species_list <- unique(latlong_data$Species)

# Loop through each species to filter and save their data
for (species in species_list) {
  # Filter data for the current species
  species_data <- subset(latlong_data, Species == species)
  
  # Write filtered data to a .filtered.txt file named after the species
  output_file <- paste0(species, ".filtered.txt")
  write.table(species_data, output_file, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
}

# Read the filtered files back into R
filtered_data <- list()

for (species in species_list) {
  file_name <- paste0(species, ".filtered.txt")
  
  if (species == "musculus") {
    # Special handling for musculus using read_delim
    temp_data <- read_delim(file_name, delim = "\t", escape_double = FALSE, trim_ws = TRUE, 
                            col_names = paste0("V", seq_len(ncol(read_delim(file_name, delim = "\t", col_names = FALSE)))))
  } else {
    # Read other species files normally
    temp_data <- read.delim(file_name, sep = "\t", header = TRUE)
  }
  
  # Standardize column names to match expected structure
  colnames(temp_data) <- c("Latitude", "Longitude", "Species")  # Ensure flipped coordinates
  
  # Add the standardized data to the list
  filtered_data[[species]] <- temp_data
}

# Combine all filtered data into one dataframe for plotting
combined_filtered_data <- do.call(rbind, filtered_data)

# Create a map for visualization
# Prepare the plotting area
png("SALIMIYAN_MapA.png", width = 4800, height = 2244, res = 300)

# Plot the world map
map("world", fill = TRUE, col = "lightgray", bg = "lightblue", lwd = 0.5)

# Assign colors and symbols for species
species_colors <- c("red", "blue", "green", "purple", "orange")
species_symbols <- c(19, 17, 15, 8, 4)

# Plot points for each species on the map
for (i in seq_along(species_list)) {
  species <- species_list[i]
  species_data <- filtered_data[[species]]
  points(species_data$Longitude, species_data$Latitude,  # Flipped here
         col = species_colors[i], pch = species_symbols[i])
}

# Add a legend
legend("topright", 
       legend = species_list, 
       col = species_colors, 
       pch = species_symbols, 
       title = "Mouse Species")
# Add axes
map.axes(cex.axis = 0.8)  # Adds axes to the map with adjusted font size

# Add a title
title(main = "Distribution of Mus musculus Species", col.main = "blue", cex.main = 1.5)

# Close the PNG file
dev.off()
