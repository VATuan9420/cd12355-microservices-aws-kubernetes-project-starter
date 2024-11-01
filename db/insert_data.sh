#! /bin/bash

POSTGRES_DB=mydatabase
POSTGRES_USERNAME=myusername

kubectl -n udacity port-forward service/coworking-db-svc 5433:5432 &

echo "Creating PostgreSQL tunnel ..."
sleep 10

echo "Starting seed data ..."
PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U $POSTGRES_USERNAME -d $POSTGRES_DB -p 5433 < 1_create_tables.sql
PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U $POSTGRES_USERNAME -d $POSTGRES_DB -p 5433 < 2_seed_users.sql
PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U $POSTGRES_USERNAME -d $POSTGRES_DB -p 5433 < 3_seed_tokens.sql