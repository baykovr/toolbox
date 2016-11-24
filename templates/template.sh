#!/bin/bash
# Robert A. Baykov <baykovr@gmail.com>
# Template for bash scripts.

# echo "# arguments called with ---->  ${@}     "
# echo "# \$1 ---------------------->  $1       "
# echo "# \$2 ---------------------->  $2       "
# echo "# path to me --------------->  ${0}     "
# echo "# parent path -------------->  ${0%/*}  "
# echo "# my name ------------------>  ${0##*/} "
# cite [1]

DEPENDENCIES=( one two three )

function usage()
{
	# ${0##*/} : this scripts name (see the template for details)
	
	echo ${0##*/} : "a template"
	echo "Usage"
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
	if [ "$EUID" -ne "0" ] ; then
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
# argument count can be accessed via $#
# interstingly enough, it does not include the program itself
# i.e. "./script arg1 arg2" produces an argument count of 2, not 3 as would in C style argc