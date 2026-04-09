#!/bin/bash

# Removes the index from all PDFs and replaces originals
# while preserving directory structure

# Safely collect files (handles spaces, newlines, etc.)
mapfile -d '' PDF_FILES < <(find . -type f -name "*.pdf" -print0)

# Create the output directory
mkdir -p noindex

# Process each file safely
for PAGE_FILE in "${PDF_FILES[@]}"; do
  # Get relative path (remove leading ./)
  REL_PATH="${PAGE_FILE#./}"

  # Extract directory and filename
  REL_DIR=$(dirname "$REL_PATH")
  PAGE_BASE_NAME=$(basename "$REL_PATH" .pdf)

  echo "> Removing index from: $REL_PATH"

  # Recreate directory structure in noindex
  mkdir -p "noindex/$REL_DIR"

  # Process file
  pdftk A="$PAGE_FILE" cat A1-end output "noindex/$REL_DIR/$PAGE_BASE_NAME.pdf"
done

echo "> Replacing original files with processed versions"

# Replace originals safely
for PAGE_FILE in "${PDF_FILES[@]}"; do
  REL_PATH="${PAGE_FILE#./}"

  # Delete original
  rm -f "$PAGE_FILE"

  # Move processed file back to original location
  mv "noindex/$REL_PATH" "$PAGE_FILE"
done

# Clean up temporary directory
rm -rf noindex


echo -e "> Finishedremoving indexes"
