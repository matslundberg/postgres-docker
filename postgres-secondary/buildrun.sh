#!/bin/bash

docker rm pg_sec
docker build -t pg_sec . 
docker run -p 5432:5432 -v `pwd`/wals:/wals --name pg_sec pg_sec 
