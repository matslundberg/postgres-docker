# Prototype of postgres and wal-g

Quick demo of Postgres WAL File shipping via S3 using wal-g.
1. Starts up primary and creates an initial backup using `wal-g backup-push`.
1. Primary continues to ship WAL files to S3 using `wal-g wal-push`
1. Starts up secondary and restores from LATEST backup using `wal-g backup-fetch`
1. Secondary continues to poll for WAL files in S3 using `wal-g wal-fetch`

Authentication info for S3 currently hardcoded into /wal-g.sh in respective container in this simple prototype.

## Cmds

```
postgres-primary/load-data-into-master.sh # Load data into master
docker exec postgres-docker_pg_pri_1 /usr/local/bin/create_backup # Creat a backup while running
wal-g backup-list LATEST # List all backups
```