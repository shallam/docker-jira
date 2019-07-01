#!/bin/bash

docker build -t my-ideas/jira . && \
  docker run -p 8080:8080 -it \
    -v jira.dat3:/var/atlassian/application-data/jira \
    -v jira.pg3:/var/lib/postgresql/10/main \
    -e PG_PASS=dajee  \
    --network jira-net my-ideas/jira


    docker run -p -d --name myideas.jira --rm \
      -v myideas.jira.data:/var/atlassian/application-data/jira \
      -v myideas.jira.pgdata:/var/lib/postgresql/10/main \
      -e VIRTUAL_HOST=jira-test.my-ideas.it  \
      myideas/jira-server
