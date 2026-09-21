This is a collection of rough scripts to help with batch procesing PDF files. Some refinement is needed.

All Linux BASH. Prerequisite packages are listed in the script comments. Original files are replaced by edited files, consider working on copies.

## Running guidance

Place file such as pdfoccr.sh in a directory of PDFs, either copy manually, use git clone, or use the wget command such as:\
$ `wget https://github.com/scottbouch/pdfocr-batch/raw/refs/heads/main/pdfocr.sh` \
\
Make executable with:\
`$ chmod +x pdfocr.sh`\
\
And run with:\
`$ ./pdfocr.sh`

# pdfocr.sh
Batch process a directory of plain PDFs, to PDFs with OCR layer.

# jpgpdfocr.sh
Batch process a directory of JPGs, combine to a single PDF with OCR layer.\
Dependencies:\
`$ sudo apt install tesseract-ocr`\
`$ sudo apt install poppler-utils`

# pdfappend.sh
Batch process a directory of PDFs, append another PDF to the end, randomly selected from an /append directory.
Dependencies:\
`sudo apt install pdftk`\
`sudo apt install imagemagick`\
`sudo apt install poppler-utils`\
`sudo apt install  tesseract-ocr`

# pdfappendsub.sh
Similar to padappend, but includes all .pdf files found in sub-directories too.

# pdfnoindex.sh
Batch process a directory of PDFs, removes index bookmarks - handy after splitting a big PDF into smaller chunks.\

# pdfmain.sh
Calls other files from pdfmain directory to process PDFs, these files do not self-delete. Copy pdfmain.sh to PDF working directory and execute there. Other scripts need to be in /home/(user)/Documents/pdf-batch-scripts/pdfmain \
Dependencies:\
`sudo apt install pdftk`\
`sudo apt install imagemagick`\
`sudo apt install poppler-utils`\
`sudo apt install  tesseract-ocr`

\
TODO: Refine settings of ocr scripts to reduce file sizes.
