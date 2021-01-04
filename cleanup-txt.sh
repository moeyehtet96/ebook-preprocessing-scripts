#!/bin/zsh

# script manual
usage() {
  printf "Usage: ./cleanup-txt.sh -i [input file with directory] -o [output directory]\n -i: input file with directory (E.g - /home/user/Documents/sample.txt)\n -o: output directory (E.g - /home/user/output-folder)"
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

# strip to file name with no extension
in_name=$(basename -- "${i}")
in_name_noext="${in_name%.*}"
out_name=${o}/${in_name_noext}-cleaned.txt
echo "${in_name_noext}"
echo "${out_name}"

echo "Cleaning up text file..."

# remove single line breaks (to form into paragraphs)
perl -00 -lpe 'tr/\n//d' ${i} >${out_name}

# remove blank lines separating paragraphs
perl -ni -e 'print if /\S/' ${out_name}

# remove form feed characters
perl -pi -e 's/\f//g' ${out_name}

echo "All done!"
