FROM odoo:19

USER root

# Only install extra deps IF your custom modules require them
RUN apt-get update && apt-get install -y \
    libldap2-dev \
    libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy custom addons
COPY ./extra-addons /mnt/extra-addons

# Copy config
COPY odoo.conf /etc/odoo/odoo.conf

# Optional custom entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# =========================
# Odoo persistent storage
# =========================
RUN mkdir -p /data/odoo \
    && mkdir -p /data/odoo/sessions \
    && mkdir -p /data/odoo/filestore \
    && chown -R odoo:odoo /data/odoo \
    && chmod -R 775 /data/odoo

# Fix permissions (ONLY what you added)
RUN chown -R odoo:odoo /mnt/extra-addons /etc/odoo /entrypoint.sh

USER odoo

EXPOSE 8069

CMD ["/entrypoint.sh"]