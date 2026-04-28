FROM python:3.10-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    node-less \
    npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# 🔥 Clone Odoo 19 during build (Choice A)
RUN git clone https://github.com/odoo/odoo.git --depth 1 --branch 19.0 odoo

# Set working dir
WORKDIR /opt/odoo

# Install Python deps
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy your custom addons
COPY ./custom_addons /mnt/extra-addons

# Copy config + entrypoint
COPY docker/odoo.conf /etc/odoo/odoo.conf
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8069

CMD ["/entrypoint.sh"]