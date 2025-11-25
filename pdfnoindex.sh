#!/bin/bash

# Removes the index from all PDFs in the same directory - useful after splitting a PDF into sections and finding the index still exists for the now absent serctions.

# Create a list of file names
PDF_FILES=$(find . -name "*.pdf")

# Create the output directory if it doesn't exist
mkdir -p noindex

  # Process each page
  for PAGE_FILE in $PDF_FILES; do
    # Extract the filename without the .pdf extension
    PAGE_BASE_NAME=$(basename "$PAGE_FILE" .pdf)

    echo "> Removing index from: $PAGE_BASE_NAME"

        pdftk A="$PAGE_BASE_NAME.pdf" cat A1-end output "noindex/$PAGE_BASE_NAME.pdf"
  done

echo -e "> Finished!\n> Remember to delete or move the pdfnoindex.sh file!"
