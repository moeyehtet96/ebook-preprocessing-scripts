# Shell scripts for preprocessing pdf files before creating ebooks

## pdf2txt

Script for converting pdf files to text files; won't work with pdfs with split pages

### Dependencies

- pdftoppm
  - for converting pdf pages to images
  - Arch Linux: `sudo pacman -S poppler`
- tesseract
  - to convert images to text using OCR
  - Arch Linux: `sudo pacman -S tesseract`
  - add `mya.traineddata` file to tessdata folder (Credit to: Myanmar OCR)

### How to Use

`./pdf2txt.sh -i [input file with directory] -o [output directory] -r [true or false]`

Example:

`./pdf2txt.sh -i /home/user/Documents/sample.pdf -o /home/user/output-folder -r true`

## split-pdf

Script for converting double-page PDF into single-page PDF

### Dependencies

- pdftk
  - for splitting double-page pdf into single double-page pdfs
  - Arch Linux: `sudo pacman -S pdftk`
- ghostscript
  - for splitting individual double-page pdfs into two single-page pdfs
  - Arch Linux: `sudo pacman -S ghostscript`

### How to Use

`./split-pdf.sh -i [input file with directory] -o [output directory]`

Example:

`./split-pdf.sh -i /home/user/Documents/sample.pdf -o /home/user/output-folder -r true`

## cleanup-txt

Script for cleaning up the resulting text file from OCR.

Currently:

- remove single line breaks to form paragraphs
- remove blank lines separating the paragraphs
- remove form feed characters

(May add more in the future.)

### Dependencies

- perl
  - for regular expression replacements
  - Arch Linux: should already be installed but, if not, `sudo pacman -S perl`

### How to Use

`./cleanup-txt.sh -i /home/user/Documents/sample.txt -o /home/user/output-folder -r true`
