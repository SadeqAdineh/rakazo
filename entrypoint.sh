#!/bin/bash
set -e

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until pg_isready -U ${POSTGRES_USER:-rakazo} -d ${POSTGRES_DB:-rakazo}; do
  sleep 2
done

# Run migrations
echo "Running database migrations..."
pnpm --filter @rakazo/db exec prisma migrate deploy

# Start supervisord
echo "Starting supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
