#!/bin/bash
set -e

# Enable proxy
#RUN xmlstarlet ed --inplace  --insert '/Server/Service/Connector' -t attr -n 'proxyName' -v "jira.my-ideas.it" /opt/atlassian/jira/conf/server.xml && \
#    xmlstarlet ed --inplace  --insert '/Server/Service/Connector' -t attr -n 'proxyPort' -v "443" /opt/atlassian/jira/conf/server.xml && \
#    xmlstarlet ed --inplace  --insert '/Server/Service/Connector' -t attr -n 'scheme' -v "https" /opt/atlassian/jira/conf/server.xml


if [[ "$1" = 'start-jira' ]]; then
    exec /opt/atlassian/jira/bin/start-jira.sh -fg
else
    exec "$@"
fi

