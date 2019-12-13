#!/bin/bash
set -e

if [[ "$1" = 'start-jira' ]]; then
    exec /opt/atlassian/jira/bin/start-jira.sh -fg
else
    exec "$@"
fi