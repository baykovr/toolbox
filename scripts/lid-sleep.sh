#!/bin/bash
# Robert A. Baykov <baykovr@gmail.com>
# lid-sleep : set systemd lid close behavior

conf_file="/etc/systemd/logind.conf"

function usage()
{
	echo $0 : $DESCRIPTION
	echo "Usage"
	echo -e "\t" $0 "on    # set to sleep on lid close."
	echo -e "\t" $0 "off   # set to do nothing on lid close."
	echo -e "\t" $0 "apply # restart systemd-logind.service"
	echo -e "\t" $0 "show  # show current setting in $conf_file"
	exit 1
}

function show_cur()
{
	echo "[...] Current setting: " ; grep "HandleLidSwitch" $conf_file
}

function set_lid_behavior()
{
	if [ $1 == "on" ] ; then
		echo -e "[...] Uncommenting HandleLidSwitch=ignore"
		sed -i '/HandleLidSwitch=ignore/c\HandleLidSwitch=ignore' $conf_file
	elif [ $1 == "off" ] ; then
		echo -e "[...] Commenting out HandleLidSwitch=ignore"
		sed -i '/HandleLidSwitch=ignore/c\#HandleLidSwitch=ignore' $conf_file
	elif [ $1 == "apply" ] ; then
		systemctl restart systemd-logind.service
	elif [ $1 == "show" ] ; then
		show_cur
	else
		usage
	fi
}

function main()
{
	if [ "$#" -eq 1 ] ; then
		set_lid_behavior "$@"
	else
		usage "$@"
	fi
}
main "$@"
