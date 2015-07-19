#!/bin/bash
# The goal is to make wifi interfaces more tollerant of poor network connetions,
# however this needs a lot of work...todo. 07/18/15

function usage()
{
	echo "This script attempts to modify tcp and wireless interface settings"
	echo "to be more tolerant of poor connections." 
	echo "Uses iwconfig and sysctl"
	echo "Wireless device is queried from /sys/class/net"
	exit 0
}

function argparse()
{
	while getopts "h?" opt; do
		case "$opt" in
			h|\?) usage "$@" ;;
		esac
	done
}

function modwireless()
{	
	if [ "$UID" -ne "0" ] ; then
		echo "Script requires root."
		exit -1
	fi
	# a silly way to find the wireless device
	DEV=$(ls -1 /sys/class/net | grep w)
	echo "[...] modifying " $DEV
	# settings david recommends, god know's where he got them.
	DEV=$(echo $DEV | grep -Eo '.* ')
	echo "[...] taking " $DEV
	iwconfig $DEV frag 255
	iwconfig $DEV rts 1
	iwconfig $DEV retry 0
	sysctl net.ipv4.tcp_frto=1
	#sysctl net.ipv4.tcp_frto_response=2 # no longer works 05.27.15
	sysctl net.ipv4.tcp_low_latency=1
}

function main()
{
	argparse "$@"
	modwireless "$@"	
}
main "$@"
