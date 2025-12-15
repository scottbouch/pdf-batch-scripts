#!/bin/bash

# Get list of numeric jpg files, sorted numerically
files=( $(ls -1 | grep -E '^[0-9]+\.jpg$' | sort -n) )

count=${#files[@]}
echo "Total files: $count"

if [[ $count -eq 0 ]]; then
    echo "No numbered jpg files found."
    exit 1
fi

# Create temporary directory
tmpdir=$(mktemp -d)

# Copy originals into temp in normal order
for file in "${files[@]}"; do
    cp "$file" "$tmpdir/"
done

# Now copy back in reverse order, overwriting originals but keeping names
j=$((count-1))
for file in "${files[@]}"; do
    revfile="${files[$j]}"
    cp "$tmpdir/$revfile" "$file"
    ((j--))
done

# Clean up
rm -r "$tmpdir"

echo "Reordering complete (same filenames, reversed content)."

