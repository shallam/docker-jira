# docker-jira
Docker image for Atlassian JIRA with TLS/SSL support enabled

This repo contains the sources for this [HakunaCloud blog post](https://hakuna.cloud/blog/jira_self_hosted.html)  

# Build
To build this image, you must have a `PKCS12` certificate for SSL/TLS. You can get one for free from Let's Encrypt using [certbot](https://certbot.eff.org/):
```
certbot certonly --standalone -d jira.example.com 
``` 

Convert it in a PKCS12 archive format:
```
sudo openssl pkcs12  -export -out ./jira.example.com.p12 \
                -in /etc/letsencrypt/live/jira.example.com/fullchain.pem \
                -inkey /etc/letsencrypt/live/jira.example.com/privkey.pem \
                -name jira
```

Last step is to copy the `PKCS12` archive in the same path of this `Dockerfile`.

Then build the image as usual:
```
docker build -t hakunacloud/jira .
```
 
# Run
Atlassian JIRA requires a PostgreSQL database.  To make data persistent, we need 2 volumes to hold data for Jira datadir and PostgreSQL datadir. 

We also need to create a 
```bash
docker network create jira-net

docker volume create jira_data
docker volume create jira_pg
```

Start a PostgreSQL database:
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


And jira server
```bash
# Start Jira
docker run --name jira -it  \
    --network jira-net \
    -v jira_data:/var/atlassian/application-data/jira \   
    -p 8443:8443 \
    hakunacloud/jira
```

Open a browser to https://localhost:8443 and proceed with the configuration of JIRA 
