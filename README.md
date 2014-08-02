# PostgreSQL Docker Container

This is a docker container for PostgreSQL 5.6. It is designed to be
configurable with ease and to allow for persistent storage on the host
(optional).

The default configuration is intentionally minimal.

## Testing

Without any special configuration, you should be able to start the container
and connect to it on port 5432.

```
-bash$ docker run -d -p 5432:5432 d11wtq/postgres
abcdef1234567890abcdef1234567890abcdef1234567890ab

-bash$ nc -z localhost 5432
Connection to localhost port 5432 [tcp] succeeded!
```

A more complete test can be done by testing the server-client interaction:

```
-bash$ docker run -d --name server d11wtq/postgres
abcdef1234567890abcdef1234567890abcdef1234567890ab

-bash$ docker run -ti \
>   --link server:server \
>   -e PGPASSWORD=postgres \
>   d11wtq/postgres \
>   psql -h server -U postgres

psql (9.3.5)
Type "help" for help.

postgres=#
```

## Configuration

The container runs postgres in the foreground under a user called 'default'.
The data directory is stored at /postgres/data, and a minimal postgresql.conf
is stored in the data directory.

The 'postgres' user is the superuser and has the password 'postgres'.

For convenience, there is an empty database called 'default' and a user
'default' with password 'default' that has full privileges on this database
(but not any others).  It is advised to use this for application integration.

The default pg_hba.conf allows connections from any user on any host provided
they have the MD5 password.

```
#     database  user  source  auth
host  all       all   all     md5
```

To adjust the configuration of postgres, you can add \*.conf files to
/postgres/conf.d/, either by mounting a volume, or by using this image as a
base image. If you have any need to change pg_hba.conf or pg_ident.conf,
specify their locations in here.

The data directory is lazily initialized on container startup, unless it is
already initialized. This allows you to mount /postgres/data as a volume if you
need long-lived persistence on the host.

Logs are written to stdout and stderr.

## Example Usage

### Server

The following runs postgres, keeping the data directory on the host and
supplying configuration to adjust the default search_path.

```
-bash$ docker run -d \
>   --name postgres \
>   -v $(pwd)/data:/postgres/data \
>   -v $(pwd)/conf.d:/postgres/conf.d \
>   d11wtq/postgres
abcdef1234567890abcdef1234567890abcdef1234567890ab
-bash$
```

The shared volume conf.d/ contains a file named 'search_path.conf' with the
contents:

``` config
search_path = '"$user", public'
```

The shared volume data/ is initially empty, but will be initialized by the
container.

### Client Access

If you need to try something in the psql client, the intended way to do this is
to use two containers in a client-server setup. Start the server container with
a name, then start a second container linking to that name, but running 'bash',
or 'psql' instead of the default server startup script.

Connecting a client to the above server would look like this:

```
-bash$ docker run -ti \
>   --link postgres:server \
>   d11wtq/postgres \
>   psql -h server -U default
Password:

psql (9.3.5)
Type "help" for help.

default=>
```

If you really want to work in a single container, you can run
/usr/local/bin/start_postgres from a bash shell in the container. Press Ctrl-C
to stop the server.
