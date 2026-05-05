FROM odoo:19

USER root

RUN apt-get update && apt-get install -y \
    libldap2-dev \
    libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# custom addons
COPY ./extra-addons /mnt/extra-addons

# config
COPY odoo.conf /etc/odoo/odoo.conf

# entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ensure directories exist
RUN mkdir /mnt/extra-addons /etc/odoo

USER odoo

EXPOSE 8069

CMD ["/entrypoint.sh"]