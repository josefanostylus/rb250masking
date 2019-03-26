#!/bin/bash
# courtesy of: http://redsymbol.net/articles/unofficial-bash-strict-mode/
# (helps with debugging)
# set -e: immediately exit if we find a non zero
# set -u: undefined references cause errors
# set -o: single error causes full pipeline failure.
set -euo pipefail
IFS=$'\n\t'


in_file="${1:?Must specify the input image file as argument 1.}"
mask_file="${2:?Must specify the mask file as argument 2.}"
out_file="${3:? Must specify the output filename as argument 3.}"
border_size=1
dpi=100
dims=$(identify -format "%wx%h" "${mask_file}")

convert \( \
    \( "${in_file}" -resize ${dims}^  -compose Copy \
        -gravity center -extent ${dims} -quality 100 \) \
    "${mask_file}" \
    -compose DstIn -alpha Set -composite  \
\) \( \
    \( "${mask_file}" -background black -compose over -flatten -alpha off \
		-channel A -morphology EdgeIn Diamond +channel \
		+level-colors white,black \)\
    -morphology erode:$border_size Diamond \
	-alpha Set -background none -transparent white  \
\) \
-compose DstOver -composite -units pixelsperinch -density 100 \
"${out_file}"



