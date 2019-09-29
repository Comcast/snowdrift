#!/bin/bash
#
# Entrypoint for our dest container.
#


# Errors are fatal
set -e

#
# Git doesn't honor non-executable permissions, and I've seen
# weird behavior that I can't reproduce where the key has permissions
# of 644, which makes ssh complain.  So let's just change this to 400 here
# to completely sidestep that problem.
#
chmod 400 /testing.key

#
# Wait pretty much forever (or at least a long time) to keep the container running.
#
/bin/sleep 999999

