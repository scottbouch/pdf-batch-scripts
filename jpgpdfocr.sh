#!/bin/bash

# OCR all .jpg images in a directory and combine them into a single PDF

# Find JPG files and sort them in natural numeric order
JPG_FILES=$(find . -maxdepth 1 -type f -iname "*.jpg" | sort -V)

mkdir -p ocrpdf
mkdir -p output

echo "> Starting OCR process..."

# OCR each JPG
for PAGE_FILE in $JPG_FILES; do
    PAGE_BASE_NAME=$(basename "$PAGE_FILE" .jpg)

    echo "> OCR analysing JPG: $PAGE_BASE_NAME"

    tesseract "$PAGE_FILE" "ocrpdf/$PAGE_BASE_NAME" pdf
done

echo "> OCR complete. Merging PDFs..."

# Natural-sort the PDF files too
OCR_PDFS=$(ls ocrpdf/*.pdf 2>/dev/null | sort -V)

if [[ -z "$OCR_PDFS" ]]; then
    echo "Error: No OCR PDFs found to merge."
    exit 1
fi

OUTPUT="output/combined.pdf"
pdfunite $OCR_PDFS "$OUTPUT"

echo "> Done! Combined PDF saved as: $OUTPUT"

