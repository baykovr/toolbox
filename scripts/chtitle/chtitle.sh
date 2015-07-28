#!/bin/bash
# chtitle : term title changer
# Robert Baykov <baykvor@gmail.com> 05.14.15
# Acknowledgments
#     Ric Lister <ric@giccs.georgetown.edu>
#     	http://tldp.org/HOWTO/Xterm-Title.html
# 	  Bruno Bronosky <richard@bronosky.com>
# ---------------------------------------------------------
# Shells & Terms: zsh, xterm/rxvt

# Exit codes
# 0 : ok
# 1 : usage error
# 2 : unsupported terminal
# 3 : unsupported shell

DESCRIPTION="a title changer"

# reset getopts
OPTIND=1    
FORCE=0
USE_CUR_DIR=0
TITLE=""

function usage()
{
	# ${0##*/} : this scripts name (see the template for details)
	echo ${0##*/} : $DESCRIPTION
	echo "Usage"
	echo -e "\t" ${0##*/} "-h : display usage."
	echo -e "\t" ${0##*/} "-t [title] : set the title"
	echo -e "\t" ${0##*/} "-c         : use the current folder name as title."
	echo -e "\t" ${0##*/} "-f         : ignore the terminal type when setting title."  
	exit 1
}
function chtitle()
{
	if [ "$USE_CUR_DIR" == "1" ] ; then
		echo -e "[set] : '${PWD}' " "\e]0;${PWD}\a"
		exit 0
	else
		echo -e "[set] : '$TITLE' " "\e]0;$TITLE\a"
		exit 0
	fi
}
function check_term_supported()
{
	if [ "$FORCE" -eq "1" ] ; then
		return
	fi

	# Check term type
	if [ "$TERM" == *"xterm"* ] || \
	 [ "$TERM" == *"rxvt"* ]; then
		echo "[ ! ] unsupported terminal $TERM"
		exit 2
	fi
	# Check shell type
	if [ "$SHELL" == *"zsh"* ] ; then
	 	echo "[ ! ] unsupported shell $SHELL"
	 	exit 3
	fi
}

function argparse()
{
	while getopts "h?t:cf" opt; do
	    case "$opt" in
	    h|\?)
	        usage "$@"
	        exit 0        ;;
	    t)  TITLE=$OPTARG ;;
	    c)  USE_CUR_DIR=1 ;;
	    f)  FORCE=1       ;;
	    esac
	done
}

function check_usage()
{
	# since getopts is limited in function (no mutual exclusive args)
	# we will do a few usage checks here.
	 
	if [ "$TITLE" != "" ] && [ "$USE_CUR_DIR" == 1 ]; then
		echo "[ ! ] cannot specify a title and use the current directory as a title."
		exit 1
	fi
}

function main()
{
	if [ "$#" -eq 0 ] ; then
		usage "$@"
	else
		if [ "$#" != 1 ] ; then
			argparse "$@"
		else
			# check if the first argument is a dash
			arg="$@"
			if  [ ${arg:0:1} == '-' ] ; then
				argparse "$@"
			else
				TITLE=$1
			fi
		fi
	 	check_term_supported "$@"
	 	check_usage "$@"
	 	chtitle "$@"
	fi
}
main "$@" # $@ passes args from invocation to main.