#!/bin/bash

# Directory where you want to save the converted files
outputDir="00_converted_images"

# Create the output directory if it doesn't already exist
mkdir -p "$outputDir"

# Find and convert all .png, .jpg, .jpeg, and files in the current directory and its subdirectories
find . -type f \( -iname \*.png -o -iname \*.jpg -o -iname \*.jpeg \) | while read i; do
    # Extract just the filename without the path and prepare the new filename
    filename=$(basename -- "$i")
    newFilename="${filename%.*}.webp"
    outputPath="$outputDir/$newFilename"

    # Check if the .webp file already exists in the output directory
    if [ -f "$outputPath" ]; then
        echo "File $outputPath already exists, skipping conversion."
        continue
    fi
    
    echo "Converting $i..."
    # Convert the image, assuming Squoosh CLI automatically saves the converted file in the current working directory
    squoosh-cli --webp '{"quality":75, "effort":6}' "$i"
    
    # Move the converted file to the output directory
    # Check if a converted file exists before moving
    if [[ -f "$newFilename" ]]; then
        mv -- "$newFilename" "$outputDir/"
        echo "Moved $newFilename to $outputDir"
    else
        echo "Conversion failed for $i, or the output file does not exist."
    fi
done

echo "Conversion completed. All files are saved in $outputDir."
