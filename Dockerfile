# Dockerfile for a PostgreSQL container.
#
# Runs PostgreSQL 9.3 on port 5432 with optional host persistence.

FROM debian:buster
MAINTAINER Mats Lundberg <mats.lundberg@gmail.com>

# Get deps
#RUN apt-get update && apt-get install curl make gcc readline-common libreadline-dev zlib1g-dev zip -y -q

# Get code
#RUN curl https://ftp.postgresql.org/pub/source/v10.4/postgresql-10.4.tar.gz -o postgresql-10.4.tar.gz && tar xfz postgresql-10.4.tar.gz

ENV PG_VER 10.4
ENV PG_DIR postgresql-$PG_VER
ENV PG_PKG $PG_DIR.tar.bz2

RUN apt-get update -qq -y && apt-get install curl sudo bzip2 zip make gcc readline-common libreadline-dev zlib1g-dev -y -qq

RUN cd /tmp;                                                        \
    curl -LO http://ftp.postgresql.org/pub/source/v$PG_VER/$PG_PKG; \
    tar xvjf *.tar.bz2; rm -f *.tar.bz2;                            \
    cd $PG_DIR;                                                     \
    ./configure --prefix=/usr/local;                                \
    make world && make install-world;                               \
    cd; rm -rf /tmp/$PG_DIR

RUN sudo useradd -s /bin/bash -m postgres

ADD postgres           /postgres
ADD etc                /usr/local/etc
ADD scripts            /usr/local/scripts
ADD bin/start_postgres /usr/local/bin/start_postgres
#ADD wals               /wals

RUN sudo chmod 0755 /usr/local/bin/start_postgres
RUN sudo chown postgres: /postgres

# TEMP!
#RUN sudo chown postgres: /wals

WORKDIR /home/postgres
ENV     HOME /home/postgres
USER    postgres
EXPOSE  5432
CMD     [ "/usr/local/bin/start_postgres" ]
