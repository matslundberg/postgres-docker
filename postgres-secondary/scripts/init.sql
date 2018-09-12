/* Bootstrap script for PostgreSQL permissions */

-- Set the 'postgres' password
ALTER USER "postgres" PASSWORD 'postgres';

-- Give 'default' a password
CREATE USER "default" WITH PASSWORD 'default';

-- Create the 'default' database
CREATE DATABASE "default" WITH OWNER "default";
