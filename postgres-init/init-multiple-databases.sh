#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Criar database para Evolution API se não existir
    SELECT 'CREATE DATABASE evolution'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'evolution')\gexec
    
    -- Dar permissões para o usuário
    GRANT ALL PRIVILEGES ON DATABASE evolution TO $POSTGRES_USER;
EOSQL

echo "Multiple databases initialized successfully!"