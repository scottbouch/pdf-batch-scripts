#!/bin/bash
echo "Removing spaces in file names"
~/Documents/pdf-batch-scripts/jpgmain/removespaces.sh
echo "Finished space removal, starting JPG OCR"
~/Documents/pdf-batch-scripts/jpgmain/jpgpdfocr2.sh
echo "Finished PDF OCR, starting appending last pages"
~/Documents/pdf-batch-scripts/jpgmain/pdfappend-nodel.sh
echo "Compressing PDF"
~/Documents/pdf-batch-scripts/jpgmain/pdfcompresssub.sh

# Self-delete script
rm -- "$0"

echo "Everything is finished"

