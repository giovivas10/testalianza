CREATE SCHEMA IF NOT EXISTS test;
SET search_path TO test;
ALTER ROLE postgres SET search_path = test;
ALTER ROLE aplication SET search_path = test;