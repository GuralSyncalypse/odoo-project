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

python3 /opt/odoo/odoo-bin \
    --db_host="$PGHOST" \
    --db_port="$PGPORT" \
    --db_user="$PGUSER" \
    --db_password="$PGPASSWORD" \
    -d "$PGDATABASE" \
    -i base \
    --without-demo=True \
    --stop-after-init || true

# ---- Start Odoo ----
echo "🚀 Launching Odoo server..."

exec python3 /opt/odoo/odoo-bin \
    --db_host="$PGHOST" \
    --db_port="$PGPORT" \
    --db_user="$PGUSER" \
    --db_password="$PGPASSWORD" \
    -d "$PGDATABASE" \
    --addons-path="/opt/odoo/addons,/mnt/extra-addons" \
    --http-interface=0.0.0.0 \
    --proxy-mode