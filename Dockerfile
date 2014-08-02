# Dockerfile for a PostgreSQL container.
#
# Runs PostgreSQL 9.3 on port 5432 with optional host persistence.

FROM       d11wtq/ubuntu
MAINTAINER Chris Corbyn <chris@w3style.co.uk>

ENV PG_VER 9.3.5
ENV PG_DIR postgresql-$PG_VER
ENV PG_PKG $PG_DIR.tar.bz2

RUN sudo apt-get update -qq -y

RUN cd /tmp;                                                        \
    curl -LO http://ftp.postgresql.org/pub/source/v$PG_VER/$PG_PKG; \
    tar xvjf *.tar.bz2; rm -f *.tar.bz2;                            \
    cd $PG_DIR;                                                     \
    ./configure --prefix=/usr/local;                                \
    make && make install;                                           \
    cd; rm -rf /tmp/$PG_DIR

RUN sudo useradd -s /bin/bash -m postgres

ADD postgres           /postgres
ADD etc                /usr/local/etc
ADD scripts            /usr/local/scripts
ADD bin/start_postgres /usr/local/bin/start_postgres

RUN sudo chmod 0755 /usr/local/bin/start_postgres
RUN sudo chown postgres: /postgres

WORKDIR /home/postgres
ENV     HOME /home/postgres
USER    postgres
EXPOSE  5432
CMD     [ "/usr/local/bin/start_postgres" ]
