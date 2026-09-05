FROM ghcr.io/elie222/rakazo/app:edge

# Install supervisor and other dependencies
USER root
RUN apt-get update && apt-get install -y supervisor netcat-openbsd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create directories for logs
RUN mkdir -p /var/log/supervisor /data

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch back to node user for running services
USER node

ENTRYPOINT ["/entrypoint.sh"]
