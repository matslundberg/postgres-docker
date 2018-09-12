#!/bin/bash

export WALG_S3_PREFIX=s3://your-s3-bucket
export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
export PGHOST=localhost
export PGPORT=5432
export PGUSER=postgres
export PGPASSWORD=postgres

/usr/local/bin/wal-g $1 $2