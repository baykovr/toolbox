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
# 
# You can processes all but n arguments with
#  ${@:n} e.g. echo "${@:2}" # will echo all but first arg 
DEPENDENCIES=( one two three )

function usage()
{
    # ${0##*/} : this scripts name (see the template for details)
    
    echo ${0##*/} : "a template"
    echo "Usage"
    echo -e '\t' "something"
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
    while getopts ":-:h?" opt; do
        case "$opt" in
            -) 
                case "${OPTARG}" in
                    verbose) echo "verbose" ;;
                    *)  
                        if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then 
                            echo "unknown option $OPTARG"
                            usage
                        fi ;;
                esac  ;;
            h|\?) usage "$@" ;;
        esac
    done
}

function back_dir()
{
    # Since the backup directory is not under version
    # control, create it if its missing.
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p $BACKUP_DIR
    fi

    DATE=`date +%m-%d-%Y-%H-%M-%S`
    FILENAME="backup-"$DATE".tar.gz"
    echo "Saving to : " $FILENAME
    # use --ignore-failed-read after tar if you do not have permission to some folders
    # otherwise all of tar will fail.
    tar -cvzf ../target/$FILENAME $SITE_ROOT/* 
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
#     alternatively use the argparse getops functions.
# argument count can be accessed via $#
# interstingly enough, it does not include the program itself
# i.e. "./script arg1 arg2" produces an argument count of 2, not 3 as would in C style argc
