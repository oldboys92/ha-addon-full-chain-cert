# ha-addon-full-chain-cert

![build](https://github.com/oldboys92/ha-addon-full-chain-cert/actions/workflows/build-and-push.yml/badge.svg)
![release](https://img.shields.io/github/v/release/oldboys92/ha-addon-full-chain-cert?label=release)
![ghcr-version](https://img.shields.io/container/v/ghcr.io/oldboys92/ha-addon-full-chain-cert?label=ghcr%20version)
![ghcr-pulls](https://img.shields.io/container/pulls/ghcr.io/oldboys92/ha-addon-full-chain-cert)
![license](https://img.shields.io/github/license/oldboys92/ha-addon-full-chain-cert)

Home Assistant Add-on: Full Chain Certificate

This add-on downloads a CA root certificate and creates a full-chain certificate file by concatenating an existing fullchain file with the downloaded CA root. The resulting file is written into the Home Assistant `/ssl` directory (the add-on manifest maps `ssl:rw`).

## Features

- Fetch CA root certificate from configured URL.
- Concatenate existing fullchain + CA root to create a new full-chain file.
- Runs once (fire-and-forget) and exits; exits non-zero on error so Supervisor will mark failures.

## Configuration (config.json options)

- `ca_root_url` (string) — URL to fetch CA root certificate (required).
- `current_fullchain` (string) — File name of existing full chain in `/ssl` (default: `fullchain.pem`).
- `ca_cert` (string) — File name to save downloaded CA cert in `/ssl` (default: `CA_root.pem`).
- `extended_fullchain` (string) — File name to create for the new full chain in `/ssl` (default: `chain-full.pem`).

When running as a Home Assistant add-on, configure those options in the add-on UI (they are written to `/data/options.json`). When running the container directly you can provide the same values as environment variables: `CA_ROOT_URL`, `CURRENT_FULLCHAIN`, `CA_CERT`, `EXTENDED_FULLCHAIN`.

## Usage as Home Assistant add-on

1. Install the add-on in the Home Assistant Supervisor.
2. Set `ca_root_url` and other options in the add-on configuration UI.
3. Start the add-on. The add-on will:
   - download the CA root,
   - check for the configured existing fullchain in `/ssl`,
   - create the concatenated full-chain file in `/ssl`, and
   - exit (successful run returns 0; failures return non-zero).

## Run the container directly (docker)

Example (replace values and local paths as needed):

```bash
docker run --rm \
  -e CA_ROOT_URL="https://example.com/ca_root.pem" \
  -e CURRENT_FULLCHAIN="fullchain.pem" \
  -e CA_CERT="CA_root.pem" \
  -e EXTENDED_FULLCHAIN="chain-full.pem" \
  -v /path/to/host/ssl:/ssl \
  ghcr.io/oldboys92/ha-addon-full-chain-cert:latest
```

- Mount your Home Assistant `/ssl` path (or another directory) to `/ssl` in the container so the add-on can find the existing fullchain and write the new file.
- The container runs once and then exits.

## Published container and tags

The repository publishes images to GitHub Container Registry (GHCR) at:

- ghcr.io/oldboys92/ha-addon-full-chain-cert

When the repository build runs (see `.github/workflows/build-and-push.yml`), images are pushed with these tags:

- `latest` — the latest build from `main`
- commit SHA — e.g. `ghcr.io/oldboys92/ha-addon-full-chain-cert:<commit-sha>`
- semantic version — extracted from `config.json`'s `version` field, e.g. `ghcr.io/oldboys92/ha-addon-full-chain-cert:0.1.0`
- `v` + semantic version — e.g. `ghcr.io/oldboys92/ha-addon-full-chain-cert:v0.1.0`

You can pull a specific semantic version:

```bash
docker pull ghcr.io/oldboys92/ha-addon-full-chain-cert:0.1.0
```
