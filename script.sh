#!/bin/bash
# courtesy of: http://redsymbol.net/articles/unofficial-bash-strict-mode/
# (helps with debugging)
# set -e: immediately exit if we find a non zero
# set -u: undefined references cause errors
# set -o: single error causes full pipeline failure.
set -euo pipefail
IFS=$'\n\t'

dims=$(identify -format "%wx%h" RB250_SM.png)
convert \( \
    \( legging_sm.jpg -resize ${dims}^  -compose Copy \
        -gravity center -extent ${dims} -quality 100 \) \
    RB250_SM.png \
    -compose DstIn -alpha Set -composite  \
\) \
\( \
    \( \( RB250_SM.png \
        -background black -flatten \
        \) \
	    -alpha off \
		-channel A -morphology EdgeIn Diamond +channel \
		+level-colors white,black \
    \)\
    -morphology erode:1 Diamond \
	-alpha Set -background none -transparent white \
\) \
-compose DstOver -composite -units pixelsperinch -density 100 \
result.png



