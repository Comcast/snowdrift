#!/bin/bash
#
# Thie script runs a full test of our Snowdrift functionality.
#
# AFAIK, testing frameworks for bash don't really exist, so 
# I'm gonna have to improvise here.
#

# Errors are fatal
set -e


# Change to this script's directory
pushd $(dirname $0) > /dev/null

echo "# "
echo "# Starting up Docker containers..."
echo "# "
docker-compose up -d

echo "# "
echo "# Running Snowdrift tests..."
echo "# "
docker-compose exec testing /mnt/snowdrift /mnt/files/snowdrift-tests.txt

echo "# Done!"

