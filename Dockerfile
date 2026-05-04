FROM odoo:19

# =========================
# System dependencies (IMPORTANT)
# =========================
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    g++ \
    python3-dev \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libjpeg-dev \
    zlib1g-dev \
    node-less \
    npm \
    && rm -rf /var/lib/apt/lists/*

# =========================
# Copy extra addons
# =========================
COPY ./extra-addons /mnt/extra-addons

# =========================
# Config + entrypoint
# =========================
COPY odoo.conf /etc/odoo/odoo.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# =========================
# Odoo port
# =========================
EXPOSE 8069

# =========================
# Start Odoo
# =========================
# Create non-root user
RUN useradd -m -d /home/odoo -s /bin/bash odoo \
    && chown -R odoo:odoo /opt /mnt /etc/odoo

USER odoo

CMD ["/entrypoint.sh"]