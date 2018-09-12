# Dockerfile for a PostgreSQL container.
#
# Runs PostgreSQL 10.4 on port 5432 with optional host persistence, based on Debian Buster.

FROM debian:buster
MAINTAINER Mats Lundberg <mats.lundberg@gmail.com>

ENV PG_VER 10.4
ENV PG_DIR postgresql-$PG_VER
ENV PG_PKG $PG_DIR.tar.bz2

# Install deps
RUN apt-get update -qq -y && apt-get install curl sudo bzip2 zip make gcc readline-common libreadline-dev zlib1g-dev -y -qq
RUN apt-get update -qq -y && apt-get install golang git -y

#RUN mkdir /wal-g && cd /wal-g && go get github.com/wal-g/wal-g && make all
RUN mkdir /wal-g && cd /wal-g && go get github.com/wal-g/wal-g && git clone https://github.com/wal-g/wal-g.git /wal-g && export GOBIN=/usr/local/bin && make install


# Get code and compile
RUN cd /tmp;                                                        \
    curl -LO http://ftp.postgresql.org/pub/source/v$PG_VER/$PG_PKG; \
    tar xvjf *.tar.bz2; rm -f *.tar.bz2;                            \
    cd $PG_DIR;                                                     \
    ./configure --prefix=/usr/local;                                \
    make world && make install-world;                               \
    cd; rm -rf /tmp/$PG_DIR

# Add user and config
RUN sudo useradd -s /bin/bash -m postgres

ADD postgres           /postgres
ADD etc                /usr/local/etc
ADD scripts            /usr/local/scripts
ADD bin/start_postgres /usr/local/bin/start_postgres
ADD bin/wal-g.sh       /wal-g.sh

RUN sudo chmod 0755 /usr/local/bin/start_postgres
RUN sudo chown postgres: /postgres

# Start the thing...
WORKDIR /home/postgres
ENV     HOME /home/postgres
USER    postgres
EXPOSE  5432
CMD     [ "/usr/local/bin/start_postgres" ]
