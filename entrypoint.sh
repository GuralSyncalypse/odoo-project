#!/bin/bash

set -e

echo "Starting Odoo..."

python3 /opt/odoo/odoo-bin \
    --db_host="$PGHOST" \
    --db_port="$PGPORT" \
    --db_user="$PGUSER" \
    --db_password="$PGPASSWORD" \
    --addons-path="/opt/odoo/addons,/mnt/extra-addons" \
    --http-interface=0.0.0.0 \
    --proxy-mode