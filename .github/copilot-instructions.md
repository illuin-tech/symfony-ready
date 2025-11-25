# Copilot Instructions for AI Agents

## Project Overview
This repository provides Docker images for Symfony-ready PHP environments, supporting multiple PHP, Composer, and Node.js versions. Images are based on Alpine or Debian, and include common PHP extensions for Symfony projects.

## Key Structure
- Each versioned directory (e.g., `7.3/`, `8.2-node-22/`) contains a `Dockerfile` for a specific PHP/Node/Composer/Linux combination.
- The `README.md` documents all available image tags and their stack details.

## Developer Workflows
- **Build an image:**
  - Navigate to the desired version directory and run:
    ```sh
    docker build -t <your-tag> .
    ```
- **Tag conventions:**
  - Tags follow the format described in `README.md` (e.g., `8.2-node-22` for PHP 8.2, Node 22, Composer 2, Alpine 3.20).
- **Extending images:**
  - To add packages or extensions, edit the relevant `Dockerfile` in the target version directory.

## Project Conventions
- **Minimal base images:**
  - Use Alpine or Debian as the base, as specified per version.
- **PHP extensions:**
  - All images include: `intl`, `json`, `mbstring`, `pdo`, `pdo_pgsql`, `zip`, `bcmath`, `sockets`, `ldap`, `gd`.
- **Composer and Node.js:**
  - Composer and Node.js versions are pinned per image, not globally.

## Integration Points
- No application code is present; this repo is for Docker image definitions only.
- Images are intended for use as base images in Symfony or PHP projects.

## Examples
- To build the PHP 8.2 + Node 22 image:
  ```sh
  cd 8.2-node-22
  docker build -t illuin/symfony-ready:8.2-node-22 .
  ```
- To add a PHP extension, modify the `Dockerfile` in the relevant directory and rebuild.

## References
- See `README.md` for the full matrix of supported versions and tags.
- Each version directory contains a single `Dockerfile` as the source of truth for that image.

---

**AI agents:**
- Focus on Dockerfile editing, version matrix maintenance, and ensuring extension consistency across images.
- Do not add application code or unrelated files.
- Keep instructions and conventions up to date with `README.md`.
