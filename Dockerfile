# Basics

FROM ubuntu:latest
MAINTAINER Artem Dekhtyar
RUN apt-get update
RUN apt-get install -q -y git-core

# Install Java 7

RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y software-properties-common python-software-properties
RUN DEBIAN_FRONTEND=noninteractive apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install oracle-java8-installer curl libmysql-java mysql-client -y

# Install JIRA

RUN /usr/sbin/useradd --create-home --home-dir /usr/local/jira --shell /bin/bash jira
RUN curl -Lks https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.0.5-jira-7.0.5-x64.bin -o /root/jira.tar.gz && \
    curl -Lks http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz -o /root/mysql-connector-java.tar.gz

RUN mkdir -p /opt/jira && \
    mkdir -p /opt/jira-home

RUN tar -zxf /root/jira.tar.gz --strip=1 -C /opt/jira && \
    tar -zxf /root/mysql-connector-java.tar.gz --strip=1 -C /opt/jira/lib --wildcards --no-anchored 'mysql-connector-*-bin.jar'

RUN echo "jira.home = /opt/jira-home" > /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties && \
    export JIRA_HOME=/opt/jira-home

# Launching Jira

WORKDIR /opt/jira-home
RUN rm -f /opt/jira-home/.jira-home.lock
EXPOSE 8080:8080
CMD ["/opt/jira/bin/start-jira.sh", "-fg"]