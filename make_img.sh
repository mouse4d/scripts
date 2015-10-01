#!/bin/bash

function usage() {

	echo "Usage: make_img.sh -s size [-o dir] images"
	echo "-s size  ex: 125x67"
	echo "-o dir   directory where to put the resulted images"
	echo "images   iamges to resize"
}

baseSize=30x30
output_dir=
## List of options the program will accept;
optstring=s:o:h

##Get command-line options
while getopts $optstring opt
do
  case $opt in
    s) baseSize=$OPTARG ;;
	o) output_dir=$OPTARG ;;
	h) usage ;;
    *) exit 1 ;;
esac done

shift $(( ${OPTIND} - 1 ))


function getsizes () { #usage getsizes <width>x<height>

	local IFS='x'
	set -- ${baseSize}

	_width=$1
	_height=$2
}

function valint() {

	case "$1" in
	*[!0-9]* ) false;;
	*) true;;
esac
}


function checkValue() { #usage checkValue <value> <value name>

local value=$1
local valueName=$2

	if [ -z "$value" ]; then	
	
		echo "$valueName has no value"
		exit 1
	fi

	if ! valint "$value" ; then
	
		echo "\"$value\" is a wrong value for $valueName"
		exit 1	
	fi
}

function resizeImage() { #usage resizeImage <@ sufix> <size> <original>  

	local suffix=$1
	local size=$2
	local image=$3

	resizedImage=${image##*/}
	resizedImage=${resizedImage%.png}
	resizedImage=${resizedImage%\@?x}
	resizedImage="${resizedImage}${suffix}.png"

	if [ -n "$output_dir" ]; then
		
		resizedImage="${output_dir}/${resizedImage}"
	fi

	echo "Resizing image $image to $resizedImage"
	convert "$image" -resize "$size" "$resizedImage"
}

function resizeImages() { #usage resizeImage <@ sufix> <size> <original images> 

local suffix=$1
local size=$2

shift 2

for image in $@; do

	resizeImage "$suffix" "$size" "$image"

done
}


getsizes "$baseSize"

width=${_width}
height=${_height}

checkValue "$width" "width"
checkValue "$height" "height"


x2width=$(( ${width} + ${width} ))
x2height=$(( ${height} + ${height} ))

x3width=$(( ${x2width} + ${width} ))
x3height=$(( ${x2height} + ${height} ))

resizeImages "@3x" "${x3width}x${x3height}" "$@"
resizeImages "@2x" "${x2width}x${x2height}" "$@"
resizeImages "" "${width}x${height}" "$@"

