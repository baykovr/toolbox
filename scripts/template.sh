#!/bin/bash
# Robert A. Baykov <baykovr@gmail.com>
# Template for bash scripts.


DEPENDENCIES=( one two three )

function usage()
{
	# echo usage of script.
	exit 0
}

function check_dependencies()
{
	pass=true
	for d in "${DEPENDENCIES[@]}"; do
	    hash "$d" &>/dev/null 
    	if [ $? != 0 ]; then
    		echo "[ ! ] $d required"
    		pass=false
    	fi
	done 

	if [ $pass == false ]; then
		echo '[ ! ] unmet dependencies, aborting. '
		exit -1
	fi
}

function argparse()
{
	while getopts "h?" opt; do
		case "$opt" in
			h|\?) usage "$@" ;;
		esac
	done
}

function require_root()
{
	if [ "$UID" -ne "0" ] ; then
		echo "[ ! ] script requires root, aborting."
		exit -1
	fi
}

function action()
{
	echo "hello world."
}

function main()
{
	argparse "$@"
	action   "$@"	
}
main "$@"

# Side notes:
# if you need to handle arguments from command line, pass them using "$@"
# 	alternatively use the argparse getops functions.
# arg count can be accessed via $#