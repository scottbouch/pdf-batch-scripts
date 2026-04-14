#!/usr/bin/env bash

# Exit on errors
set -euo pipefail

# Find all PDF files recursively
find . -type f -iname "*.pdf" -print0 | while IFS= read -r -d '' file; do
    echo "Processing: $file"

    # Create a temporary file in same directory
    tmp="${file}.tmp.pdf"

    # Run Ghostscript compression
    gs -sDEVICE=pdfwrite \
       -dCompatibilityLevel=1.4 \
       -dPDFSETTINGS=/ebook \
       -dNOPAUSE \
       -dQUIET \
       -dBATCH \
       -sOutputFile="$tmp" \
       "$file"

    # Only replace original if Ghostscript succeeded and output exists
    if [[ -f "$tmp" && -s "$tmp" ]]; then
        mv -f "$tmp" "$file"
        echo "Replaced: $file"
    else
        echo "Failed: $file"
        rm -f "$tmp"
    fi

done

# Self-delete script
rm -- "$0"

echo "All PDFs processed."
