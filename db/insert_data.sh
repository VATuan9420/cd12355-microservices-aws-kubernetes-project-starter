#! /bin/bash

POSTGRES_DB=mydatabase
POSTGRES_USERNAME=myuser
POSTGRES_PASSWORD=mypassword

kubectl port-forward service/postgresql-service 5432:5432 &

echo "Creating PostgreSQL tunnel ..."
sleep 10

echo "Starting seed data ..."
PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U $POSTGRES_USERNAME -d $POSTGRES_DB -p 5432 < 1_create_tables.sql
PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U $POSTGRES_USERNAME -d $POSTGRES_DB -p 5432 < 2_seed_users.sql
PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U $POSTGRES_USERNAME -d $POSTGRES_DB -p 5432 < 3_seed_tokens.sql