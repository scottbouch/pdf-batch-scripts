This is a collection of rough scripts to help with batch procesing PDF files. Some refinement is needed.

All Linux BASH

# pdfocr.sh
Batch process a directory of plain PDFs, to PDFs with OCR layer.\

## Prerequisite packages

Prerequisite packages are listed in the script comments.

## Running guidance

Place pdfocr.sh in a directory of PDFs, either copy manually, use git clone, or use the wget command such as:\
$ wget https://github.com/scottbouch/pdfocr-batch/raw/refs/heads/main/pdfocr.sh \
\
Make executable with:\
$ chmod +x pdfocr.sh\
\
And run with:\
$ ./pdfocr.sh

## Warning

This script deletes the original PDF files and replces them with the OCR versions. If you want to keep the originals, work on copies of them.

TODO: Refine settings to reduce file sizes.

# jpgpdfocr.sh
Batch process a directory of JPGs, combine to a single PDF with OCR layer.\

# pdfappend.sh
Batch process a directory of PDFs, append another PDF to the end, randomly selected from an /append directory.\

# pdfappendsub.sh
Similar to padappend, but includes all .pdf files found in sub-directories too.\

# pdfnoindex.sh
Batch process a directory of PDFs, removes index bookmarks - handy after splitting a big PDF into smaller chunks.\
