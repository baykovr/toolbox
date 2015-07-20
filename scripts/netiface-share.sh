#!/bin/bash
# This is basically just wiki link below:
# https://wiki.archlinux.org/index.php/Internet_sharing
# Robert A. Baykov <baykovr@gmail.com>
# Last Edit: 07.19.15

DEPENDENCIES=( sysctl ip iptables )
OPTIND=1          # reset getopts
inet_interface='' # internet connected interface
cnet_interface='' # client connected interface
function usage()
{
	echo -e "netiface-share -i [internet-interface0] -c [client-interface1]"
	echo -e "\t" " -i : network interface connected to internet       i.e. eth0"
	echo -e "\t" " -c : network interface connected to client machine i.e. eth1"
	exit 0
}

function check_dependencies()
{
	pass=true
	for d in "${DEPENDENCIES[@]}"; do
	    hash "$d" &>/dev/null 
    	if [ $? != 0 ]; then
    		echo "[ ! ] $d is required."
    		pass=false
    	fi
	done 

	if [ $pass == false ]; then
		echo '[ ! ] unmet dependencies, aborting. '
		exit -1
	fi
}

function require_root()
{
	if [ "$UID" -ne "0" ] ; then
		echo "[ ! ] script requires root."
		exit -1
	fi
}

function argparse()
{
	if [ $# != 4 ] ; then
		usage "@"
	fi

	while getopts "h?i:c:" opt; do
		case "$opt" in
			h|\?) usage "$@" ;;
			i)  inet_interface=$OPTARG ;;
			c)  cnet_interface=$OPTARG ;;
		esac
	done
}
function iface_ok()
{
	echo "[...] Internet connected interface: " $inet_interface
	echo "[...] Client connected inferface  : " $cnet_interface
	read -p "[ ? ] Looks ok? [y/N] " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo ''
	    setup_sharing
	fi
}
function setup_sharing()
{
	echo '[...] setting' $cnet_interface 'to static ip 192.168.111.100'
	ip link set up dev $cnet_interface
	ip addr add 192.168.111.100/24 dev $cnet_interface 
	
	echo '[...] enabling packet forwarding.'
	sysctl net.ipv4.ip_forward=1
	
	#echo '[DBG]'
	#sysctl -a | grep forward

	echo '[...] enabling NAT using iptables, good luck.'
	iptables -t nat -A POSTROUTING -o $inet_interface -j MASQUERADE
	iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
	iptables -A FORWARD -i $cnet_interface -o $inet_interface -j ACCEPT

	#echo '[DBG]'
	#iptables --list

	echo '[...] it is recommended you manualy verify iptable rules (iptables --list)'
	echo '[...] to clear all rules (iptables --flush).'
	echo '[...] if no errors configure the client machine as such:'
	echo '[...] choose ip address XXX (i.e. 201) and connected interface (i.e.) eth0 and run:'
	echo -e '[ # ] \t ip addr add 192.168.111.XXX/24 dev eth0' 
	echo -e '[ # ] \t ip link set up dev eth0'
	echo -e '[ # ] \t ip route add default via 192.168.111.100 dev eth0'
	echo -e '[ # ] \t edit /etc/resolv.conf to add DNS (i.e.append nameserver 8.8.8.8 to use Google DNS)'
}

function main()
{
	require_root "$@"
	argparse 	 "$@"
	iface_ok
	
}
main "$@"
