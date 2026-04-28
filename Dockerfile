FROM python:3.10-slim

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
# Workdir
# =========================
WORKDIR /opt

# =========================
# Clone Odoo 19 (Choice A)
# =========================
RUN git clone https://github.com/odoo/odoo.git --depth 1 --branch 19.0 odoo

WORKDIR /opt/odoo

# =========================
# Upgrade pip first (important for build stability)
# =========================
RUN pip install --upgrade pip setuptools wheel

# =========================
# Install Odoo requirements (correct path)
# =========================
RUN pip install -r requirements.txt

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
CMD ["/entrypoint.sh"]