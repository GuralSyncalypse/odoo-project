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

echo "✅ Database config:"
echo "   Host: $PGHOST"
echo "   Port: $PGPORT"
echo "   User: $PGUSER"
echo "   DB:   $PGDATABASE"

# ---- Force init (will silently skip if already initialized) ----
echo "⚙️ Running base module init (if applicable)..."

odoo -c /etc/odoo/odoo.conf \
    -d "$PGDATABASE" \
    -i base \
    --without-demo=all \
    --stop-after-init

# ---- Start Odoo ----
echo "🚀 Launching Odoo server..."

odoo -c /etc/odoo/odoo.conf