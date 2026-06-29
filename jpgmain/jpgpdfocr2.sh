#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(pwd)"

echo "> Starting OCR process..."

# Process directories from deepest first
find "$ROOT_DIR" -type d | sort -r | while IFS= read -r dir; do

    # Find JPG/JPEG files safely (handles spaces)
    mapfile -d '' JPG_FILES < <(find "$dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | sort -z -V)

    # Skip if no JPGs
    (( ${#JPG_FILES[@]} == 0 )) && continue

    # --- UPDATED SECTION: build full relative path name ---
    REL_PATH="${dir#$ROOT_DIR/}"

    # Handle case where dir == ROOT_DIR
    if [[ "$dir" == "$ROOT_DIR" ]]; then
        REL_PATH="root"
    fi

    # Convert path to single string (replace / with _)
    DIR_NAME="${REL_PATH//\//_}"
    # Optional: replace spaces with underscores
    DIR_NAME="${DIR_NAME// /_}"
    # -----------------------------------------------------

    TEMP_DIR="$dir/ocrpdf_tmp"

    mkdir -p "$TEMP_DIR"

    echo "> Processing directory: $DIR_NAME"

    OCR_PDFS=()

    # OCR each JPG
    for PAGE_FILE in "${JPG_FILES[@]}"; do
        PAGE_BASE_NAME="$(basename "${PAGE_FILE%.*}")"

        echo "  > OCR analysing: $PAGE_BASE_NAME"

        OUT_BASE="$TEMP_DIR/$PAGE_BASE_NAME"

        tesseract "$PAGE_FILE" "$OUT_BASE" pdf

        OCR_PDFS+=("$OUT_BASE.pdf")
    done

    # Ensure PDFs exist
    if (( ${#OCR_PDFS[@]} == 0 )); then
        echo "  > No OCR PDFs created in $DIR_NAME"
        continue
    fi

    # Output PDF in root directory
    OUTPUT_PDF="$ROOT_DIR/$DIR_NAME.pdf"

    echo "  > Merging into: $OUTPUT_PDF"

    pdfunite "${OCR_PDFS[@]}" "$OUTPUT_PDF"

    # Cleanup temp + original JPGs
    rm -rf "$TEMP_DIR"
    rm -f "${JPG_FILES[@]}"

done

echo "> Cleaning up subdirectories..."

# Remove all subdirectories (leave only PDFs + script)
find "$ROOT_DIR" -mindepth 1 -type d -exec rm -rf {} +

echo "> Done! All PDFs are in: $ROOT_DIR"
