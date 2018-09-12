#!/bin/bash

rm wals/*
docker rm pg_pri
docker build -t pg_pri . 
docker run -p 5432:5432 -v `pwd`/wals:/wals --name pg_pri pg_pri 
