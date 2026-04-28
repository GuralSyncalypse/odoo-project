#!/bin/bash
set -e

echo "🚀 Starting Odoo..."

# ---- Debug env ----
echo "🔍 Checking PostgreSQL environment variables..."
env | grep PG || true

# ---- Validate required variables ----
if [ -z "$PGHOST" ] || [ -z "$PGUSER" ] || [ -z "$PGPASSWORD" ]; then
  echo "❌ Missing PostgreSQL environment variables!"
  exit 1
fi

PGPORT="${PGPORT:-5432}"
DB_NAME="${DB_NAME:-odoo}"

echo "✅ Database config:"
echo "   Host: $PGHOST"
echo "   Port: $PGPORT"
echo "   User: $PGUSER"
echo "   DB:   $DB_NAME"

# ---- Wait for Postgres ----
echo "⏳ Waiting for PostgreSQL..."
until pg_isready -h "$PGHOST" -p "$PGPORT" -U "$PGUSER"; do
  sleep 2
done

echo "✅ PostgreSQL is ready!"

# ---- Check if DB exists ----
DB_EXISTS=$(psql "postgresql://$PGUSER:$PGPASSWORD@$PGHOST:$PGPORT/postgres" -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")

# ---- Init if not exists ----
if [ "$DB_EXISTS" != "1" ]; then
  echo "🆕 Database does not exist. Initializing with base module..."

  python3 /opt/odoo/odoo-bin \
    --db_host="$PGHOST" \
    --db_port="$PGPORT" \
    --db_user="$PGUSER" \
    --db_password="$PGPASSWORD" \
    -d "$DB_NAME" \
    -i base \
    --without-demo=all \
    --stop-after-init

  echo "✅ Database initialized!"
else
  echo "📦 Database already exists. Skipping init."
fi

# ---- Start Odoo normally ----
echo "🚀 Launching Odoo server..."

exec python3 /opt/odoo/odoo-bin \
    --db_host="$PGHOST" \
    --db_port="$PGPORT" \
    --db_user="$PGUSER" \
    --db_password="$PGPASSWORD" \
    -d "$DB_NAME" \
    --addons-path="/opt/odoo/addons,/mnt/extra-addons" \
    --http-interface=0.0.0.0 \
    --proxy-mode