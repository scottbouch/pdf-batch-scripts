#!/usr/bin/env bash

# File shared at https://github.com/scottbouch/pdfocr-batch 

# Prerequisite packages
# Prerequisite packages to use this script, some of these will already be included in desktop distributions, for Ubuntu Server I had to install all:
#
# pdftk
# libpng-dev libjpeg-dev libtiff-dev
# imagemagick
# poppler-utils
# tesseract

# Find all PDFs safely
mapfile -d '' PDF_FILES < <(find . -type f -name "*.pdf" -print0)

# Create the output directory if it doesn't exist
mkdir -p output

for PDF_FILE in "${PDF_FILES[@]}"; do

  # Extract the filename without extension
  BASE_NAME=$(basename "$PDF_FILE" .pdf)

  # Create directories
  mkdir -p "$BASE_NAME"

  echo -e "> Processing file: $BASE_NAME\n> Splitting PDF into individual pages"

  # Split PDF
  pdftk "$PDF_FILE" burst output "$BASE_NAME/%03d.pdf"

  mkdir -p "$BASE_NAME/png/ocrpdf"

  # Read page files safely
  mapfile -d '' PAGE_FILES < <(find "$BASE_NAME" -type f -name "*.pdf" -print0)

  # Process each page
  for PAGE_FILE in "${PAGE_FILES[@]}"; do
    PAGE_BASE_NAME=$(basename "$PAGE_FILE" .pdf)

    echo "> Converting to PNG: $BASE_NAME page $PAGE_BASE_NAME"

    convert -units PixelsPerInch -density 300 \
        "$PAGE_FILE" "$BASE_NAME/png/$PAGE_BASE_NAME.png"

    echo "> OCR analysing PNG: $BASE_NAME page $PAGE_BASE_NAME and saving PDF of page"

    tesseract "$BASE_NAME/png/$PAGE_BASE_NAME.png" \
        "$BASE_NAME/png/ocrpdf/$PAGE_BASE_NAME" pdf
  done

  echo "> Merging all pages of $BASE_NAME back together"

  # Build merge list safely
  mapfile -d '' MERGE_FILES < <(
      find "$BASE_NAME/png/ocrpdf" -type f -name "*.pdf" -print0 | sort -z
  )

  if (( ${#MERGE_FILES[@]} > 0 )); then
    pdfunite "${MERGE_FILES[@]}" "output/${BASE_NAME}.pdf"
  else
    echo "No OCR files found for merging in $BASE_NAME/png/ocrpdf"
  fi

  echo "> Deleting original PDF and intermediate files & folder"

  rm -f "$PDF_FILE"
  rm -rf "$BASE_NAME"

done

echo "> Final tidy up"

mv output/* .
rmdir output

# Remove copy of script from working directory
rm -- "$0"

echo -e "> Finished!!"

