#!/bin/bash
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

function red(){
echo -e "$RED$*$NORMAL$"
}
function green(){
echo -e "$GREEN$*$NORMAL"
}
function yellow(){
echo -e "$YELLOW$*$NORMAL"
}

green  "#:----: TEST OK!"
yellow "#:----: TEST OK!"
red    "#:----: TEST OK!"

echo $(tput setaf 3)  & lspci
