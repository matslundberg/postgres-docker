#!/bin/bash

psql -h localhost -U postgres < data-load.sql
