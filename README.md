# docker-jira
Docker image that embed Atlassian JIRA v8.2.2. 

# Run
To make data persistent, we need a database and 2 volumes (jira's datadir and PostgreSQL datadir). And a network to connect the db and jira.
```bash
docker volume create jira_data
docker volume create jira_install
docker volume create jira_pg
docker network create jira-net
```

Then, we can start the db
```bash
# Start PostgreSQL
docker run --name jira_pg \
    --network jira-net \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -e POSTGRES_USER=jira \
    -e POSTGRES_DB=jira  \
    -v jira_pg:/var/lib/postgresql/data \
    -d postgres
```


and jira server
```bash
# Start Jira
docker run --name jira -d  \
    --network jira-net \
    -v jira_data:/var/atlassian/application-data/jira \
    -v jira_install:/opt/atlassian/jira \
    -p 8080:8080 \
    hakunacloud/jira:8.2.2-test
```

Open a browser to http://localhost:8080 and proceed with the configuration of JIRA 

# TODO


## General
- [x] Start and configure jira. Stop the container. Start jira again. All the settings are still there
- [ ] Try to checkpoint and restore manually using criu
- [ ]  Create a script that run criu at startup and shutdown

## Jira Image
- Add a script that configure the hostname at startup (xmlstarlet)



