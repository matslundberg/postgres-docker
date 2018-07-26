#!/bin/bash

rm wals/*
docker rm postgres_custom_wal
docker build -t postgres_custom_wal . 
docker run -p 5432:5432 -v `pwd`/wals:/wals --name postgres_custom_wal postgres_custom_wal 
