#!/usr/bin/env bash

# Rename files first
find . -type f -name "* *" -print0 |
while IFS= read -r -d '' item; do
    dir="${item%/*}"
    base="${item##*/}"
    new_base="${base// /_}"

    if [[ "$base" != "$new_base" ]]; then
        mv -v -- "$item" "$dir/$new_base"
    fi
done

# Then rename directories (deepest first)
find . -depth -type d -name "* *" -print0 |
while IFS= read -r -d '' item; do
    parent="${item%/*}"
    base="${item##*/}"
    new_base="${base// /_}"

    if [[ "$base" != "$new_base" ]]; then
        mv -v -- "$item" "$parent/$new_base"
    fi
done
