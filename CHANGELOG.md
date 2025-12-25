# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Placeholder for upcoming changes.

## [0.1.0] - 2025-12-24

### Added
- Initial release of "Full Chain Certificate" Home Assistant add-on.
- Feature: Download a CA root certificate from a configured URL.
- Feature: Concatenate an existing fullchain with the downloaded CA root to produce a combined full-chain file.
- Runs once (fire-and-forget) and exits with non-zero on error so Supervisor will mark failures.
- Docker image published to GitHub Container Registry (GHCR) with tags:
  - `latest`
  - commit SHA
  - semantic version (e.g., `0.1.0`)
  - `v0.1.0`

### Documentation
- README updated with usage and docker/run examples.
- Add-on manifest (`config.json`) includes `version: "0.1.0"`.

### Notes for maintainers
- Architecture matrix in `config.json` lists: `armv7`, `armhf`, `aarch64`, `amd64`, `i386`.
  - Current CI builds (GitHub Actions) produce: `linux/arm64`, `linux/amd64`, `linux/arm/v7`.
  - Consider aligning `config.json.arch` with actual built platforms, or extend the build workflow to produce `linux/386` (i386) and appropriate `armhf` images if those are required.
- `config.json` sets `"privileged": true`. Evaluate whether this elevated permission is necessary; if not required, set to `false` to reduce security exposure.
- No automated tests are included in this release.

---

For full details, see the repository README and `config.json`.
