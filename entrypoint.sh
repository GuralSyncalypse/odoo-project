#!/bin/bash
set -e

echo "🚀 Starting Odoo..."

# ---- Debug env (VERY important on Railway) ----
echo "🔍 Checking PostgreSQL environment variables..."
env | grep PG || true

# ---- Validate required variables ----
if [ -z "$PGHOST" ] || [ -z "$PGUSER" ] || [ -z "$PGPASSWORD" ]; then
  echo "❌ Missing PostgreSQL environment variables!"
  echo "PGHOST=$PGHOST"
  echo "PGUSER=$PGUSER"
  echo "PGPASSWORD is set? $( [ -n "$PGPASSWORD" ] && echo yes || echo no )"
  exit 1
fi

# ---- Defaults ----
PGPORT="${PGPORT:-5432}"

echo "✅ Database config:"
echo "   Host: $PGHOST"
echo "   Port: $PGPORT"
echo "   User: $PGUSER"

# ---- Start Odoo ----
exec python3 /opt/odoo/odoo-bin \
    --db_host="$PGHOST" \
    --db_port="$PGPORT" \
    --db_user="$PGUSER" \
    --db_password="$PGPASSWORD" \
    --addons-path="/opt/odoo/addons,/mnt/extra-addons" \
    --http-interface=0.0.0.0 \
    --proxy-mode