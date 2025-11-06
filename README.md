# pdfocr-batch
Batch process a directory of plain PDFs, to PDFs with OCR layer.

## Prerequisite packages

Prerequisite packages to use this script, some of these will already be included in desktop distributions, for Ubuntu Server I had to install all:\
\
pdftk\
libpng-dev libjpeg-dev libtiff-dev\
imagemagick\
poppler-utils

## Running guidance

Place pdfocr-batch.sh in a directory of PDFs, either copy manually, use git clone, or use wget such as:\
wget https://github.com/scottbouch/pdfocr-batch/raw/refs/heads/main/pdfocr.sh \
\
Make executable with:\
chmod +x pdfocr.sh
\
And run with:\
./pdfocr-batch.sh


(Temporary directories of intermediate pdf and png files are left in place presently while in development. Delete these directories once happy with finished PDF files)
