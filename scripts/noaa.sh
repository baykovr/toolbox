#!/bin/bash
# Robert A. Baykov <baykovr@gmail.com>
# Fetch NOAA weather reports in cli.

# echo "# arguments called with ---->  ${@}     "
# echo "# \$1 ---------------------->  $1       "
# echo "# \$2 ---------------------->  $2       "
# echo "# path to me --------------->  ${0}     "
# echo "# parent path -------------->  ${0%/*}  "
# echo "# my name ------------------>  ${0##*/} "
# cite [1]

DEPENDENCIES=( curl grep sed )

STATES_URL="http://weather.noaa.gov/pub/data/forecasts/city/"
STATE=''
CITY=''

# Toggle debug
# set -x

function usage()
{
	# ${0##*/} : this scripts name (see the template for details)
	echo ${0##*/} : "retrieve noaa weather data."
	echo "Usage"
	echo '\t' "-l all                : list all state codes."
	echo '\t' "-l [state]            : list available cities for state code."
	echo '\t' "-s [state] -c [city]  : print forecast for city."
	exit 0
}

function argparse()
{
	while getopts "h?l::s:c:" opt; do
		case "$opt" in
			h|\?) usage    ;;
			l)  
				if [ "$OPTARG" == "all" ] ; then 
					list_states 
				else
					STATE=$OPTARG
					list_cities
				fi
				;;
			c) 
				CITY=$OPTARG
				print_forecast ;;
			s) 
				STATE=$OPTARG  ;;
				
		esac
	done
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


function list_states()
{
	curl --silent $STATES_URL | grep -Eo ">[a-z][a-z]/<" | grep -Eo "[a-z][a-z]"
}

function list_cities()
{
	if [[ "$STATE" =~ ^[a-z]{2}$ ]] ; then
		curl -L --silent $STATES_URL/$STATE | grep -Eo "\"[a-z_-]{1,40}.txt" |\
		sed 's/"//;s/.txt//' 
	else
		echo "Invalid state code $STATE"
	fi
}
function print_forecast()
{
	curl -L --silent --fail $STATES_URL/$STATE/$CITY.txt
}

function main()
{
	argparse "$@"	
}
main "$@"
