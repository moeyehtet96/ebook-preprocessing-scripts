#!/bin/zsh

# script manual
usage() {
    printf "Usage: pdf2txt -i [input file with directory] -o [output directory] -r\n -i: input file with directory (input file with directory (E.g - /home/user/Documents/sample.pdf)\n -o: output directory (E.g - /home/user/output-folder)\n -r: include this to remove images and text folders"
}

# throw err
set -e

# receive arguments
while getopts ":i:o:r:" opts; do
    case "${opts}" in
    i)
        i=${OPTARG}
        ;;
    o)
        o=${OPTARG}
        ;;
    r)
        r=${OPTARG}
        ;;
    *)
        usage
        ;;
    esac
done

shift $((OPTIND - 1))

if [ -z "${i}" ] || [ -z "${o}" ] || [ -z "${r}" ]; then
    usage
    exit 1
fi

echo "Running pdf2txt..."

# create directory for images
img_dir="${o}/img"
mkdir -p ${img_dir}

# create directory for single-page text files
txt_dir="${o}/txt"
mkdir -p ${txt_dir}

# strip to pdf filename with and without extension
pdf_name_ext=$(basename -- "${i}")
pdf_name_noext="${pdf_name_ext%.*}"

# convert pdf to images
echo "Converting $pdf_name_ext to images..."

pdftoppm -png -r 150 ${i} ${img_dir}/${pdf_name_noext}

echo "Conversion to images finished."

# convert images to text
echo "Converting images to text..."

for img in ${img_dir}/*.png; do
    # strip to image filename with and without extension
    img_name_ext=$(basename -- "${img}")
    img_name_noext="${img_name_ext%.*}"

    tesseract ${img} ${txt_dir}/${img_name_noext} -l mya --psm 6 --dpi 150 >/dev/null 2>&1
done

echo "Conversion to text files finished."

# Combine text files into a single file
echo "Combining text files..."

cat ${txt_dir}/*.txt >${o}/${pdf_name_noext}.txt

# remove images and single-page text folders if r argument is true

if [ "${r}" = true ]; then
    rm -r ${img_dir} ${txt_dir}
fi

echo "All Done!"
