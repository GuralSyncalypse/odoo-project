#!/bin/bash

set -e

echo "Starting Odoo 19..."

cd /opt/odoo

python3 odoo-bin -c /etc/odoo/odoo.conf