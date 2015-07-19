#!/bin/bash
# Downloads websites and embeded links recursively for offline reading
DIR="brogramming"
SITE="reddit.com/r/programming"
 wget \
     --directory-prefix=$DIR\
     --level=3\
     --recursive \
     --quiet\
     --convert-links \
     --span-hosts\
     	$SITE
