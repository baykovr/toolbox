#!/bin/bash
# source this script in your script.

# Colors
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

# Print error message and exit script.
function require_root()
{
	if [ "$UID" -ne "0" ] ; then
		echo "[ ! ] script requires root."
		exit -1
	fi
}
