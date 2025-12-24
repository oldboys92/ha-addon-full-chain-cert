FROM alpine:3.18

# Install required packages: bash for the script, curl to fetch CA root,
# jq to read /data/options.json, and ca-certificates for TLS.
RUN apk add --no-cache bash curl jq ca-certificates

WORKDIR /app

# Copy start script and make executable
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Ensure expected mount points/dirs exist with sensible permissions
RUN mkdir -p /ssl /data \
  && chmod 755 /ssl /data

# Expose common env var for clarity (script still reads CA_ROOT_URL etc.)
ENV SSL_DIR=/ssl

VOLUME ["/ssl", "/data"]

# Start the add-on
CMD ["/run.sh"]
