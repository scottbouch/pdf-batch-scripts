#!/bin/bash

# ---------------- CONFIG ----------------
DEVICE="escl:http://192.168.1.100:80"
FORMAT="--format=jpeg --mode=Color --source=ADF --resolution=300dpi"

# ---------------- USER INPUT ----------------
read -p "Enter output PDF filename (without .pdf): " PDF_NAME
PDF_NAME="${PDF_NAME%.pdf}"

[[ -z "$PDF_NAME" ]] && { echo "PDF filename cannot be empty."; exit 1; }

echo -e "Select scan size:\n1 = A4 feeder\n2 = 6\" x 8.5\" feeder\n3 = 8.5\" x 11\" feeder"
read -n1 -p "Choice: " SIZE_CHOICE
echo

case "$SIZE_CHOICE" in
    1) X_SIZE=220; Y_SIZE=300; echo "Selected: A4 feeder" ;; # Allowed 10mm extra width, and 3mm extra height
    2) X_SIZE=152; Y_SIZE=216; echo "Selected: 6\" x 8.5\" feeder" ;;
    3) X_SIZE=220; Y_SIZE=281; echo "Selected: 8.5\" x 11\" feeder" ;; # paper is 216 x 279, but allowrd extra
    *) echo "Invalid choice"; exit 1 ;;
esac

# ---------------- FUNCTIONS ----------------

scan_pages() {
    local prefix=$1
    mkdir -p "$prefix"
    echo -e "\n - Scanning $prefix pages..."
    scanimage --device-name="$DEVICE" $FORMAT -x "$X_SIZE" -y "$Y_SIZE" --batch="$prefix/%03d.jpg"
}

prompt_scan_even() {
    read -n1 -p $'\n - Completed odd sides. Load even sides and press:\nY = scan even sides\nN = finish\nChoice: ' choice
    echo
    case "$choice" in
        Y|y) return 0 ;;
        N|n) echo "Skipping even pages."; return 1 ;;
        *) echo "Invalid choice."; return 1 ;;
    esac
}

# Reorder even pages (reverse for duplex scanning)
reorder_even_pages() {
    local dir="even"
    shopt -s nullglob
    files=("$dir"/*.jpg)
    count=${#files[@]}

    (( count == 0 )) && return

    tmpdir=$(mktemp -d)
    for ((i=count-1; i>=0; i--)); do
        cp "${files[$i]}" "$tmpdir/"
    done

    rm -f "$dir"/*.jpg
    cp "$tmpdir"/* "$dir"/
    rm -r "$tmpdir"
    echo "Even pages reordered."
}

# OCR and merge PDF
create_pdf_with_ocr() {
    shopt -s nullglob

    mkdir -p tmp_pdf
    page=1

    # Read odd and even files separately
    odd_files=(odd/*.jpg)
    even_files=(even/*.jpg)

    # Sort numerically
    IFS=$'\n' odd_files=($(sort -V <<<"${odd_files[*]}"))
    IFS=$'\n' even_files=($(sort -V <<<"${even_files[*]}"))

    # Reverse even pages to match duplex order
    even_files=( $(printf "%s\n" "${even_files[@]}" | tac) )

    # Interleave odd and even
    max=${#odd_files[@]}
    for ((i=0; i<max; i++)); do
        # OCR odd page
        if [[ -f "${odd_files[$i]}" ]]; then
            tesseract "${odd_files[$i]}" "tmp_pdf/page_$(printf "%04d" "$page")" -l eng --dpi 300 pdf
            ((page++))
        fi
        # OCR corresponding even page
        if [[ $i -lt ${#even_files[@]} ]] && [[ -f "${even_files[$i]}" ]]; then
            tesseract "${even_files[$i]}" "tmp_pdf/page_$(printf "%04d" "$page")" -l eng --dpi 300 pdf
            ((page++))
        fi
    done

    pdfunite tmp_pdf/*.pdf "${PDF_NAME}.pdf"

    # Cleanup
    if [[ -s "${PDF_NAME}.pdf" ]]; then
        rm -rf tmp_pdf odd even
        echo "PDF created successfully: ${PDF_NAME}.pdf"
    else
        echo "ERROR: PDF not created correctly."
    fi
}

# ---------------- MAIN ----------------

mkdir -p odd
scan_pages "odd"

if prompt_scan_even; then
    scan_pages "even"
    reorder_even_pages
fi

create_pdf_with_ocr

