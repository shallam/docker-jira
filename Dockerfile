# JIRA
FROM ubuntu:18.04

##############
# Setup JIRA #
##############

RUN apt-get update && apt-get install -y wget xmlstarlet
COPY atlassian-jira-software-8.2.2-x64.bin /opt
WORKDIR /opt

COPY jira-unhattended.varfile /tmp/response.varfile
RUN chmod a+x atlassian-jira-software-8.2.2-x64.bin
RUN ./atlassian-jira-software-8.2.2-x64.bin -q -varfile /tmp/response.varfile


# Copy and symlink the config folder to make it persistent
WORKDIR /opt/atlassian/jira
RUN mv conf /var/atlassian/application-data/jira && ln -s /var/atlassian/application-data/jira/conf conf

VOLUME ["/var/atlassian/application-data/jira", "/opt/atlassian/jira"]


# CRIU #
#RUN apt-get install -y software-properties-common && add-apt-repository -y ppa:criu/ppa && apt-get update && apt-get install -y criu

EXPOSE 8080
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start-jira"]
