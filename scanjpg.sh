#!/bin/bash

DEVICE="escl:http://192.168.1.100:80"
FORMAT="--format=jpeg --mode=Color --source=ADF --resolution=300dpi"
BATCH_ODD="--batch=%d.jpg --batch-double"
BATCH_EVEN="--batch=even/%d.jpg --batch-start=2 --batch-double"

# ---------------- FUNCTIONS ----------------

scan_odd_pages() {
    echo -e "\n - Scanning odd pages"
    scanimage --device-name="$DEVICE" $FORMAT "$@" $BATCH_ODD
}

scan_even_pages() {
    mkdir -p even
    echo -e "\n - Scanning even pages"
    scanimage --device-name="$DEVICE" $FORMAT "$@" $BATCH_EVEN
}

reverse_even_files() {
    local dir="even"
    shopt -s nullglob

    files=("$dir"/*.jpg)
    count=${#files[@]}

    echo "Total even files to reverse order: $count"

    (( count == 0 )) && {
        echo "No even files found."
        return
    }

    tmpdir=$(mktemp -d)

    for f in "${files[@]}"; do
        cp "$f" "$tmpdir/"
    done

    for ((i=0, j=count-1; i<count; i++, j--)); do
        cp "$tmpdir/$(basename "${files[$j]}")" "${files[$i]}"
    done

    rm -r "$tmpdir"

    mv even/* .
    rmdir even

    echo "Reordering complete."
}

prompt_scan_even() {
    read -n1 -p $'\n - Completed odd sides, load even sides and press:\n - Y to scan even sides\n - N to finish\n' choice
    echo
    case "$choice" in
        Y|y) return 0 ;;
        N|n) echo "Finished."; exit 0 ;;
        *)   echo "Invalid choice."; exit 1 ;;
    esac
}

# ---------------- MAIN MENU ----------------

read -n1 -p $' - Scan size?\n - 1 = A4 feeder\n - 2 = 6" x 8.5" feeder\n - 3 = 8.5" x 11"\n' size
echo

case "$size" in
    1)
        echo " - Selected: A4 feeder"
        scan_odd_pages -x 210 -y 297
        prompt_scan_even && scan_even_pages -x 210 -y 297 && reverse_even_files
        ;;
    2)
        echo ' - Selected: 6" x 8.5" feeder'
        scan_odd_pages -x 210 -y 297
        prompt_scan_even && scan_even_pages -x 210 -y 297 && reverse_even_files
        ;;
    3)
        echo ' - Selected: 8.5" x 11" feeder'
        scan_odd_pages -x 210 -y 297
        prompt_scan_even && scan_even_pages -x 210 -y 297 && reverse_even_files
        ;;
    *)
        echo " - Unknown selection"
        exit 1
        ;;
esac

