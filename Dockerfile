FROM ubuntu:18.04

ENV JIRA_VERSION=8.5.1
RUN apt-get update && apt-get install -y wget xmlstarlet fontconfig

WORKDIR /opt

RUN wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}-x64.bin

RUN chmod a+x atlassian-jira-software-${JIRA_VERSION}-x64.bin
COPY jira-unhattended.varfile /tmp/response.varfile
RUN ./atlassian-jira-software-${JIRA_VERSION}-x64.bin -q -varfile /tmp/response.varfile

ENV DOMAIN=jira.my-ideas.it

WORKDIR /var/atlassian/application-data/jira/tls/
COPY ${DOMAIN}.p12 ./

ENV PASWD=Welcome1!

RUN xmlstarlet ed --inplace --update '/Server/Service/Connector[@port=8080]/@port' -v "8443" /opt/atlassian/jira/conf/server.xml && \
    xmlstarlet ed --inplace --update '/Server/Service/Connector[@protocol="HTTP/1.1"]/@protocol' -v "org.apache.coyote.http11.Http11NioProtocol" /opt/atlassian/jira/conf/server.xml && \
    xmlstarlet ed --inplace --delete '/Server/Service/Connector[@redirectPort=8443]/@redirectPort' /opt/atlassian/jira/conf/server.xml  && \
    xmlstarlet ed --inplace --insert '/Server/Service/Connector' -t attr -n 'SSLEnabled' -v "true" /opt/atlassian/jira/conf/server.xml  && \
    xmlstarlet ed --inplace --insert '/Server/Service/Connector' -t attr -n 'scheme' -v "https" /opt/atlassian/jira/conf/server.xml && \
    xmlstarlet ed --inplace --insert '/Server/Service/Connector' -t attr -n 'secure' -v "true" /opt/atlassian/jira/conf/server.xml && \
    xmlstarlet ed --inplace --insert '/Server/Service/Connector' -t attr -n 'keyAlias' -v "jira" /opt/atlassian/jira/conf/server.xml && \
    xmlstarlet ed --inplace --insert '/Server/Service/Connector' -t attr -n 'keystoreFile' -v "/var/atlassian/application-data/jira/tls/${DOMAIN}.keystore" /opt/atlassian/jira/conf/server.xml && \
    xmlstarlet ed --inplace --insert '/Server/Service/Connector' -t attr -n 'keystorePass' -v "${PASWD}" /opt/atlassian/jira/conf/server.xml && \
    xmlstarlet ed --inplace --insert '/Server/Service/Connector' -t attr -n 'keystoreType' -v "JKS" /opt/atlassian/jira/conf/server.xml

RUN /opt/atlassian/jira/jre/bin/keytool -importkeystore \
            -deststorepass ${PASWD} \
            -destkeypass ${PASWD} \
            -destkeystore ${DOMAIN}.keystore \
             -srckeystore ${DOMAIN}.p12 \
             -srcstoretype PKCS12 \
             -srcstorepass ${PASWD} \
             -deststoretype pkcs12 \
             -alias jira

RUN rm ${DOMAIN}.p12
VOLUME ["/var/atlassian/application-data/jira"]

EXPOSE 8443
COPY ./docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start-jira"]
