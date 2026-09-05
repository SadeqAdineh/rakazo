#!/bin/bash
set -e

# Wait for PostgreSQL to be ready using netcat
echo "Waiting for PostgreSQL to be ready at ${DATABASE_URL}..."
# Extract host and port from DATABASE_URL (assuming postgresql://user:pass@host:port/db)
DB_HOST=$(echo $DATABASE_URL | sed -E 's/^.*@([^:]+):([0-9]+)\/.*$/\1/')
DB_PORT=$(echo $DATABASE_URL | sed -E 's/^.*@([^:]+):([0-9]+)\/.*$/\2/')
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "PostgreSQL not ready yet, waiting 2s..."
  sleep 2
done

# Run migrations
echo "Running database migrations..."
pnpm --filter @rakazo/db exec prisma migrate deploy

# Start supervisord
echo "Starting supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
