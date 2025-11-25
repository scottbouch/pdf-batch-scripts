#!/bin/bash

# File shared at https://github.com/scottbouch/pdfocr-batch 

# Prerequisite packages
# Prerequisite packages to use this script, some of these will already be included in desktop distributions, for Ubuntu Server I had to install all:
#
# pdftk
# libpng-dev libjpeg-dev libtiff-dev
# imagemagick
# poppler-utils
# tesseract


# Set a more descriptive variable name
PDF_FILES=$(find . -name "*.pdf")

# Create the output directory if it doesn't exist
mkdir -p output

# Iterate through each PDF file
for PDF_FILE in $PDF_FILES; do
  # Extract the filename without the .pdf extension
  BASE_NAME=$(basename "$PDF_FILE" .pdf)

  # Create a directory for the processed file
  mkdir -p "$BASE_NAME"

  echo -e "> Processing file: $BASE_NAME\n> Splitting PDF into individual pages"

  # Split the PDF into individual pages
  pdftk "$PDF_FILE" burst output "$BASE_NAME/%03d.pdf"

  # Create directories for PNG images and OCR PDFs
  mkdir -p "$BASE_NAME/png/ocrpdf"

  # Find all the individual page PDFs
  PAGE_FILES=$(find "$BASE_NAME" -name "*.pdf")

  # Process each page
  for PAGE_FILE in $PAGE_FILES; do
    # Extract the filename without the .pdf extension
    PAGE_BASE_NAME=$(basename "$PAGE_FILE" .pdf)

    echo "> Converting to PNG: $BASE_NAME page $PAGE_BASE_NAME"

    # Convert each page to a PNG image
    convert -units PixelsPerInch -density 300 "$PAGE_FILE" "$BASE_NAME/png/$PAGE_BASE_NAME.png"

    echo "> OCR analysing PNG: $BASE_NAME page $PAGE_BASE_NAME and saving PDF of page"

    # OCR png file and produce PDF
    tesseract "$BASE_NAME/png/$PAGE_BASE_NAME.png" "$BASE_NAME/png/ocrpdf/$PAGE_BASE_NAME" pdf
  done

  echo "> Merging all pages of $BASE_NAME back together"

  # Find OCR PDF files to be merged back to multi-page documents
  # Use find with -print0 and xargs -0 to handle spaces in filenames correctly
  MERGE_FILES=$(find "$BASE_NAME/png/ocrpdf" -name "*.pdf" -print0 | sort -z | xargs -0)

  # Unite pages to pdf as per the original pdf files, name the output pdf files as per original files. Save to output directory
  # Use quotes around variables to handle spaces in filenames correctly
  if [[ -n "$MERGE_FILES" ]]; then
    pdfunite $MERGE_FILES "output/${BASE_NAME}.pdf"
  else
    echo "No OCR files found for merging in $BASE_NAME/png/ocrpdf"
  fi

  echo "> Deleting original PDF and intermediate files & folder"
  # Delete the original PDF file
  rm "$PDF_FILE"

  # Delete the intermediate files and directories
  rm -r "$BASE_NAME"

done

  echo "> Final tidy up"
  # Move all final PDFs from output directory to root rirectory
  mv output/* .

  # Delete output directory
  rmdir output

  # Delete this file
  rm pdfocr.sh

echo -e "> Finished!!"
