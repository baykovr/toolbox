#!/bin/bash
# chtitle : a simple xterm title changer
# Robert Baykov <baykvor@gmail.com> 05.14.15
# Acknowledgments
#     Ric Lister <ric@giccs.georgetown.edu>
#     	http://tldp.org/HOWTO/Xterm-Title.html
# 	  Bruno Bronosky <richard@bronosky.com>
# ---------------------------------------------------------
# Only supports zsh for now...
# Exit codes
# 0 : ok : title set
# 1 : usage invoked (invalid arguments)
# 2 : unsupported terminal
# 3 : unsupported shell
DESCRIPTION="a simple xterm title changer"

OPTIND=1    # reset getopts
IGNORE_TERM=0
USE_CUR_DIR=0
TITLE=""

function usage()
{
	echo $0 : $DESCRIPTION
	echo "Usage"
	echo -e "\t" $0 "-h : display usage."
	echo -e "\t" $0 "-t [title] : set the title"
	echo -e "\t" $0 "-c         : use the current folder name as title."
	echo -e "\t" $0 "-f         : ignore the terminal type when setting title."  
	exit 1
}
function chtitle()
{
	if [ "$USE_CUR_DIR" == "1" ] ; then
		echo -e "[ set : '${PWD##*/}' ]" "\e]0;${PWD##*/}\a"
		exit 0
	else
		echo -e "[ set : '$TITLE' ]" "\e]0;$TITLE\a"
		exit 0
	fi
}
function check_term_supported()
{
	pass=0

	if [ "$IGNORE_TERM" -eq "1" ] ; then
		return
	fi

	# Check term type
	if [ "$TERM" != "xterm" ] ; then
		echo "Unsupported terminal $TERM"
		exit 2
	fi
	# Check shell type
	if [ "$SHELL" == *"zsh"* ] ; then
	 	echo "Unsupported shell $SHELL"
	 	exit 3
	fi
}

function argparse()
{
	# sample, hti: require argument for i
	while getopts "h?t:cf" opt; do
	    case "$opt" in
	    h|\?)
	        usage "$@"
	        exit 0        ;;
	    t)  TITLE=$OPTARG ;;
	    c)  USE_CUR_DIR=1 ;;
	    f)  IGNORE_TERM=1 ;;
	    esac
	done
}

function main()
{
	if [ "$#" -eq 0 ] ; then
		usage "$@"
	else
		if [ "$#" -ne 1 ] ; then
			argparse "$@"
		else
			TITLE=$1
		fi
	 	check_term_supported "$@"
	 	chtitle "$@"
	fi
}
main "$@" # $@ passes args from invocation to main.