# pdfocr-batch
Batch process a directory of plain PDFs, to PDFs with OCR layer.\
Linux BASH

## Prerequisite packages

Prerequisite packages to use this script, some of these will already be included in desktop distributions, for Ubuntu Server I had to install all:\
\
pdftk\
libpng-dev libjpeg-dev libtiff-dev\
imagemagick\
poppler-utils\
tesseract

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
