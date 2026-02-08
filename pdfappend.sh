#!/bin/bash

# Batch process to append a randomly selected PDF to the end of a another "root" pdf. Root PDFs to be inthe same directory as this script, and appendage PDFs to be in the /append directory, ie:
# .root/padappend.sh
# .root/root.pdf's
# .root/append/appendage.pdf's

USERNAME="${SUDO_USER:-$USER}"
HOMEDIR=$(eval echo "~$USERNAME")
APPEND_DIR="$HOMEDIR/Documents/append"

# Check if append directory exists
if [ ! -d "$APPEND_DIR" ]; then
    echo "Error: Append directory '$APPEND_DIR' does not exist."
    exit 1
fi

# Find PDF files safely
mapfile -t ROOT_FILES < <(find . -maxdepth 1 -type f -name "*.pdf")
mapfile -t APPEND_FILES < <(find "$APPEND_DIR" -maxdepth 1 -type f -name "*.pdf")

# Check for PDFs
if [ ${#ROOT_FILES[@]} -eq 0 ]; then
    echo "Error: No root PDF files found in the current directory."
    exit 1
fi

if [ ${#APPEND_FILES[@]} -eq 0 ]; then
    echo "Error: No append PDF files found in the append directory."
    exit 1
fi

# Process each root file with a newly selected random append file
for ROOT_FILE in "${ROOT_FILES[@]}"; do
    # Pick a random append file
    RANDOM_APPEND=${APPEND_FILES[$RANDOM % ${#APPEND_FILES[@]}]}

    echo "Processing: $ROOT_FILE"
    echo "  → Using append file: $RANDOM_APPEND"

    MERGED_FILE="${ROOT_FILE%.pdf}_merged.pdf"

    # Merge the two PDFs
    pdfunite "$ROOT_FILE" "$RANDOM_APPEND" "$MERGED_FILE"

    # Replace original file
    mv "$MERGED_FILE" "$ROOT_FILE"

    echo "Appended and updated: $ROOT_FILE"
done

echo "Batch processing completed."

