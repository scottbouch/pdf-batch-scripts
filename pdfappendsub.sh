#!/bin/bash

# Get absolute directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPEND_DIR="$SCRIPT_DIR/append"

# Ensure append directory exists
if [ ! -d "$APPEND_DIR" ]; then
    echo "Error: Append directory '$APPEND_DIR' does not exist."
    exit 1
fi

# Find all PDF files in script directory and subdirectories (excluding append folder)
mapfile -t ROOT_FILES < <(find "$SCRIPT_DIR" -type f -name "*.pdf" ! -path "$APPEND_DIR/*")

# Find append PDF files
mapfile -t ALL_APPEND_FILES < <(find "$APPEND_DIR" -maxdepth 1 -type f -name "*.pdf")

# Validate
if [ ${#ROOT_FILES[@]} -eq 0 ]; then
    echo "Error: No root PDF files found in script directory or subdirectories."
    exit 1
fi

if [ ${#ALL_APPEND_FILES[@]} -eq 0 ]; then
    echo "Error: No append PDF files found in the append directory."
    exit 1
fi

echo "Found ${#ROOT_FILES[@]} root PDF files."
echo "Found ${#ALL_APPEND_FILES[@]} append PDF files."

# Copy append files into a working list
UNUSED_APPEND_FILES=("${ALL_APPEND_FILES[@]}")

# Function to get a non-repeating random append file
get_random_append() {
    # If we've used all append files, reset the list
    if [ ${#UNUSED_APPEND_FILES[@]} -eq 0 ]; then
        echo "All append files used once — resetting list."
        UNUSED_APPEND_FILES=("${ALL_APPEND_FILES[@]}")
    fi

    # Pick a random index from the unused list
    local idx=$((RANDOM % ${#UNUSED_APPEND_FILES[@]}))
    local selected="${UNUSED_APPEND_FILES[$idx]}"

    # Remove selected file from the unused list
    UNUSED_APPEND_FILES=("${UNUSED_APPEND_FILES[@]:0:$idx}" "${UNUSED_APPEND_FILES[@]:$((idx+1))}")

    echo "$selected"
}

# Process each root file
for ROOT_FILE in "${ROOT_FILES[@]}"; do
    RANDOM_APPEND="$(get_random_append)"

    echo "Processing: $ROOT_FILE"
    echo "  → Using append file: $RANDOM_APPEND"

    FILE_DIR="$(dirname "$ROOT_FILE")"
    BASENAME="$(basename "$ROOT_FILE")"
    TEMP_OUTPUT="${FILE_DIR}/${BASENAME%.pdf}_merged.pdf"

    # Merge
    pdfunite "$ROOT_FILE" "$RANDOM_APPEND" "$TEMP_OUTPUT"

    # Replace original
    mv -f "$TEMP_OUTPUT" "$ROOT_FILE"

    echo "Updated original file: $ROOT_FILE"
done

echo "All PDF files processed with non-repeating append strategy."

