#!/bin/bash
#
# Entrypoint for our dest container.
#


# Errors are fatal
set -e

#
# Load our iptables rules
#
iptables-restore < /mnt/files/dest-iptables.txt

#
# Start nginx in the foreground.
#
nginx -g 'daemon off;'


