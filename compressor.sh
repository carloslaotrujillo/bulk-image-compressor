#!/bin/bash

# Directory where you want to save the converted files
outputDir="00_converted_images"

# Create the output directory if it doesn't already exist
mkdir -p "$outputDir"

# Check if squoosh-cli is installed
if ! command -v squoosh-cli &> /dev/null; then
    echo "squoosh-cli could not be found, please install it first."
    exit 1
fi

# Find and convert all .png, .jpg, .jpeg, and files in the current directory and its subdirectories
find . -type f \( -iname \*.png -o -iname \*.jpg -o -iname \*.jpeg \) | while read -r i; do
    # Extract the filename and directory path
    filename=$(basename -- "$i")
    dirpath=$(dirname -- "$i")
    newFilename="${filename%.*}.webp"
    outputPath="$outputDir/$newFilename"

    # Check if the .webp file already exists in the output directory
    if [ -f "$outputPath" ]; then
        echo "File $outputPath already exists, skipping conversion."
        continue
    fi
    
    echo "Converting $i..."
    # Convert the image
    squoosh-cli --webp '{"quality":75, "effort":6}' "$i"
    
    # Check if the conversion was successful and the file exists
    if [[ -f "${dirpath}/${newFilename}" ]]; then
        mv -- "${dirpath}/${newFilename}" "$outputDir/"
        echo "Moved $newFilename to $outputDir"
    else
        echo "Conversion failed for $i, or the output file does not exist."
    fi
done

echo "Conversion completed. All files are saved in $outputDir."
