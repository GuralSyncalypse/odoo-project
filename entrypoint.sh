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
# =========================
# FIX RAILWAY VOLUME PERMS
# =========================
mkdir -p /data/odoo/sessions /data/odoo/filestore

# IMPORTANT: Railway mounts as root → must fix ownership
chown -R odoo:odoo /data/odoo
chmod -R 775 /data/odoo

echo "⚙️ Running base module init (if applicable)..."

odoo -c /etc/odoo/odoo.conf \
  --db_host="$PGHOST" \
  --db_port="$PGPORT" \
  --db_user="$PGUSER" \
  --db_password="$PGPASSWORD" \
    -d "$PGDATABASE" \
    -i base \
    --without-demo=all \
    --stop-after-init

# ---- Start Odoo ----
echo "🚀 Launching Odoo server..."

exec odoo \
  -c /etc/odoo/odoo.conf \
  --db_host="$PGHOST" \
  --db_port="$PGPORT" \
  --db_user="$PGUSER" \
  --db_password="$PGPASSWORD" \
  -d "$PGDATABASE"