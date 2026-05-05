FROM odoo:19

USER root
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

RUN mkdir -p /var/lib/odoo && \
    chown -R odoo:odoo /var/lib/odoo

# Fix permissions (ONLY what you added)
RUN chown -R odoo:odoo /mnt/extra-addons /etc/odoo /entrypoint.sh

USER odoo

EXPOSE 8069

CMD ["/entrypoint.sh"]