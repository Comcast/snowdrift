#!/bin/bash
#
# Thie script runs a full test of our Snowdrift functionality.
#
# AFAIK, testing frameworks for bash don't really exist, so 
# I'm gonna have to improvise here.
#

# Errors are fatal
set -e

#
# Define ANSI for our colors (and turning off the color)
#
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"


#
# Search for a string from the test results, and return the value.
#
function getMetric() {

	local STR=$1

	#
	# The Perl code to remove the ANSI color coding was borrowed from:
	#
	# https://superuser.com/a/561105
	#
	METRIC=$(echo "$RESULTS" | grep "${STR}" | awk '{print $5}' \
		| perl -pe 's/\x1b\[[0-9;]*[mG]//g' | tr -d '\r' | tr -d '\n' )

	echo "$METRIC"

} # End of getMetric()


#
# Compare two values with a label
#
# $1 - The label to print
# $2 - The value
# $3 - The expected value
#
function compareValues() {
	local STR=$1
	local VAL=$2
	local EXPECTED=$3

	if test "${VAL}" == "${EXPECTED}"
	then
		printf "%30s: %-14s ${GREEN}SUCCESS${NC}\n" "${STR}" "${VAL} == ${EXPECTED}"

	else
		printf "%30s: %-14s ${RED}FAIL${NC}\n" "${STR}" "${VAL} == ${EXPECTED}"

	fi

} # End of compareValues()


# Change to this script's directory
pushd $(dirname $0) > /dev/null

#
# How many containers do we have?
#
NUM=$(docker-compose ps |grep snowdrift |grep " Up " | wc -l | awk '{print $1}')
echo "# Current running containers: ${NUM}"

echo "# "
echo "# Starting up Docker containers..."
echo "# "
echo "# (If containers are being built for the first time, this..."
echo "# ...could take awhile.)"
echo "# "
docker-compose up -d

NUM2=$(docker-compose ps |grep snowdrift |grep " Up " | wc -l | awk '{print $1}')
echo "# Current running containers: ${NUM2}"

if test "$NUM" != "$NUM2"
then
	echo "# "
	echo "# Some containers were started (${NUM2} != ${NUM}),"
	echo "# so let's sleep for 10 seconds so everything spins up..."
	sleep 10
	echo "# ...continuing!"
	echo "# "
fi

echo "# "
echo "# Running Snowdrift tests..."
echo "# "
TMP=$(mktemp -t snowdrift)
docker-compose exec testing /mnt/snowdrift /mnt/files/snowdrift-tests.txt | tee $TMP

RESULTS=$(cat $TMP)
rm -f $TMP

TOTAL_HOSTS_SUCCESS=$(getMetric "Total Successful Hosts: ")
TOTAL_HOSTS_FAILED=$(getMetric "Total Failed Hosts: ")
TOTAL_CONNS_SUCCESS=$(getMetric "Total Successful Connections: ")
TOTAL_CONNS_FAILED=$(getMetric "Total Failed Connections: ")


compareValues "Total Hosts Successful" $TOTAL_HOSTS_SUCCESS "5"
compareValues "Total Hosts Failed" $TOTAL_HOSTS_FAILED "ZERO"
compareValues "Total Connections Successful" $TOTAL_CONNS_SUCCESS "18"
compareValues "Total Connections Failed" $TOTAL_CONNS_FAILED "12"


echo "# Done!"



