#!/bin/zsh

# script manual
usage() {
  printf "Usage: ./split-pdf.sh -i [input file with directory] -o [output directory]\n -i: input file with directory (E.g - /home/user/Documents/sample.pdf)\n -o: output directory (E.g - /home/user/output-folder)"
}

# throw err
set -e

# receive arguments
while getopts ":i:o:" opts; do
  case "${opts}" in
  i)
    i=${OPTARG}
    ;;
  o)
    o=${OPTARG}
    ;;
  *)
    usage
    ;;
  esac
done

shift $((OPTIND - 1))

# if no parameters defined, show usage
if [ -z "${i}" ] || [ -z "${o}" ]; then
  usage
  exit 1
fi

echo "Running split-pdf..."

# separate pdf into individual two-page files
echo "Extracting PDF pages..."
pdftk ${i} burst output ${o}/pg_%04d.pdf

# find the width and height of pdf
pw=$(cat ${o}/doc_data.txt | grep PageMediaDimensions | head -1 | awk '{print $2}')
ph=$(cat ${o}/doc_data.txt | grep PageMediaDimensions | head -1 | awk '{print $3}')

# get dimensions of single page
w2=$((pw / 2))
w2px=$((w2 * 10))
hpx=$((ph * 10))

# split into single pages
echo "Splitting into individual pages..."

for f in ${o}/pg_*.pdf; do
  # strip to basename
  f_name=$(basename -- "${f}")

  # name right and left pages
  lf=left_${f_name}
  rf=right_${f_name}

  # split pages
  gs -o ${o}/${lf} -sDEVICE=pdfwrite -g${w2px}x${hpx} -c "<</PageOffset [0 0]>> setpagedevice" -f ${f} >/dev/null 2>&1
  gs -o ${o}/${rf} -sDEVICE=pdfwrite -g${w2px}x${hpx} -c "<</PageOffset [-${w2} 0]>> setpagedevice" -f ${f} >/dev/null 2>&1
done

# sort pages
ls -1 ${o}/[lr]*.pdf | sort -n -k3 -t_ >${o}/fl

# combine into single pdf
echo "Combining pages into single PDF..."
pdftk $(cat ${o}/fl) cat output ${o}/splitted.pdf

# remove unnecessary files
rm ${o}/doc_data.txt ${o}/fl ${o}/pg_*.pdf ${o}/[lr]*.pdf

echo "All Done!"
