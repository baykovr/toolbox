#!/bin/bash

DEPENDENCIES=( truncate losetup mkswap swapon )

SWAP_SIZE=''

function usage()
{
	echo ${0##*/} : "create a slow loopback swap file for use with btrfs."
	echo -e " -s SIZE \t (M/G) i.e. -s 8G"
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
	while getopts "h?s:" opt; do
		case "$opt" in
			h|\?) usage "$@"        ;;
			   s) 
				  SWAP_SIZE=$OPTARG 
				  make_swap         ;;
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

function make_swap()
{
	# free loop device
    # create sparse swap file
 	# mount file to loop
	if swapfile=$(losetup -f) && truncate -s $SWAP_SIZE /swap &&\
	losetup $swapfile /swap && mkswap  $swapfile && swapon  $swapfile ; then
		echo 'success'
	else
		echo 'fail'
	fi
}

function main()
{
	require_root "$@"
	argparse     "$@"

}
main "$@"
