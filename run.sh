#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="/data/options.json"
SSL_DIR="/ssl"

jq_read() {
  local key="$1"
  if [ -f "$CONFIG_FILE" ]; then
    jq -r "if has(\"$key\") then .\"$key\" else \"\" end" "$CONFIG_FILE" 2>/dev/null || echo ""
  else
    echo ""
  fi
}

echo "Starting ha-addon-full-chain-cert (single run)..."

CA_ROOT_URL="${CA_ROOT_URL:-}"
CURRENT_FULLCHAIN="${CURRENT_FULLCHAIN:-}"
CA_CERT="${CA_CERT:-}"
EXTENDED_FULLCHAIN="${EXTENDED_FULLCHAIN:-}"

if [ -f "$CONFIG_FILE" ]; then
  [ -z "$CA_ROOT_URL" ] && CA_ROOT_URL="$(jq_read "ca_root_url")"
  [ -z "$CURRENT_FULLCHAIN" ] && CURRENT_FULLCHAIN="$(jq_read "current_fullchain")"
  [ -z "$CA_CERT" ] && CA_CERT="$(jq_read "ca_cert")"
  [ -z "$EXTENDED_FULLCHAIN" ] && EXTENDED_FULLCHAIN="$(jq_read "extended_fullchain")"
fi

CA_ROOT_URL="${CA_ROOT_URL:-}"
CURRENT_FULLCHAIN="${CURRENT_FULLCHAIN:-fullchain.pem}"
CA_CERT="${CA_CERT:-CA_root.pem}"
EXTENDED_FULLCHAIN="${EXTENDED_FULLCHAIN:-chain-full.pem}"

if [ -z "$CA_ROOT_URL" ]; then
  echo "ERROR: No ca_root_url set (via environment variable or /data/options.json). Exiting."
  exit 1
fi

if [ ! -d "$SSL_DIR" ]; then
  mkdir -p "$SSL_DIR" || true
fi

fetch_and_build() {
  echo "Fetching CA root from: $CA_ROOT_URL"

  if ! curl -fsSL "$CA_ROOT_URL" -o "$SSL_DIR/$CA_CERT"; then
    echo "ERROR: Failed to download CA root from $CA_ROOT_URL"
    return 2
  fi
  echo "Saved CA root to $SSL_DIR/$CA_CERT"

  if [ ! -f "$SSL_DIR/$CURRENT_FULLCHAIN" ]; then
    echo "ERROR: Existing full chain file not found: $SSL_DIR/$CURRENT_FULLCHAIN"
    return 3
  fi

  echo "Creating new full chain: $SSL_DIR/$EXTENDED_FULLCHAIN"
  if ! cat "$SSL_DIR/$CURRENT_FULLCHAIN" "$SSL_DIR/$CA_CERT" > "$SSL_DIR/$EXTENDED_FULLCHAIN"; then
    echo "ERROR: Failed to create $SSL_DIR/$EXTENDED_FULLCHAIN"
    return 4
  fi

  chmod 644 "$SSL_DIR/$EXTENDED_FULLCHAIN" || true
  echo "Created $SSL_DIR/$EXTENDED_FULLCHAIN"
  return 0
}

if fetch_and_build; then
  echo "ha-addon-full-chain-cert completed (single run). Exiting 0."
  exit 0
else
  rc=$?
  echo "ha-addon-full-chain-cert failed with exit code ${rc}. Exiting ${rc}."
  exit "${rc}"
fi
