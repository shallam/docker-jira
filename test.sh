#!/bin/bash

## FUNCTIONS ###

# Simulate a process kill
killing_me_softly () {
    echo "Killing...bye!"
    exit 0
}

# Docker send SIGTERM and later on SIGKILL
# Trap the sigterm and kill
trap killing_me_softly SIGTERM

####################
### Main Program ###
####################

# Start jira
echo "Starting jira..."

# Wait until the sigterm
while :; do
    echo "PING $(date)"
    sleep 2
done









