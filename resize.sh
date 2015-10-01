#!/bin/bash

# function usage() {

	# echo "Usage: make_img.sh -s scale [-o dir] images"
	# echo "-s scale  ex: 2"
	# echo "-o dir   directory where to put the resulted images"
	# echo "images   iamges to resize"
# }

scale=1
output_dir=
## List of options the program will accept;
optstring=s:o:h

##Get command-line options
while getopts $optstring opt
do
  case $opt in
    s) scale=$OPTARG ;;
	o) output_dir=$OPTARG ;;
	h) usage ;;
    *) exit 1 ;;
esac done


shift $(( ${OPTIND} - 1 ))

oputput_opt=
if [ -n "$output_dir" ]; then
	
	oputput_opt="-o $output_dir"
fi


for image in $@; do

	width=$( identify -format "%w" "$image" )
	height=$( identify -format "%h" "$image" )

	width=$(( $width / $scale ))
	height=$(( $height / $scale ))

	./make_img.sh -s ${width}x${height} $oputput_opt $image

done

