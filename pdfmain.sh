#!/bin/bash
echo "Starting index removal"
~/Documents/pdf-batch-scripts/pdfmain/pdfnoindex-nodel.sh
echo "Finished index removal, starting PDF OCR"
~/Documents/pdf-batch-scripts/pdfmain/pdfocr-nodel.sh
echo "Finished PDF OCR, starting appending last pages"
~/Documents/pdf-batch-scripts/pdfmain/pdfappend-nodel.sh
echo "Compressing PDF"
~/Documents/pdf-batch-scripts/pdfmain/pdfcompress-nodel.sh

# Self-delete script
rm -- "$0"

echo "Everything is finished"

