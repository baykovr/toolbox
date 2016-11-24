#!/bin/bash
# doesn't support all terminals but most
# i.e. echo $RED "message" $NORMAL
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
