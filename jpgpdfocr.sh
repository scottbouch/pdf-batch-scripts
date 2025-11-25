#!/bin/bash

# OCR character recognises all .JPG images in a directory and creates a single pdf

# Create a list of file names
JPG_FILES=$(find . -name "*.jpg")

# Create the output directory if it doesn't exist
mkdir -p ocrpdf

  # Process each page
  for PAGE_FILE in $JPG_FILES; do
    # Extract the filename without the .jpg extension
    PAGE_BASE_NAME=$(basename "$PAGE_FILE" .jpg)

    echo "> OCR analysing JPG: $PAGE_BASE_NAME and saving PDF of page"

    # OCR png file and produce PDF
    tesseract "$PAGE_BASE_NAME.jpg" "ocrpdf/$PAGE_BASE_NAME" pdf
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

echo -e "> Finished!\n> Remenber to delete or move the jpgpdfocr.sh file!"
