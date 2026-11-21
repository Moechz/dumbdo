# NOTICE — third-party components and attributions

This package (`dumbdodocker`, TOS 7 Docker application, version `2026.11.14-3`)
is an independent packaging by Moechz of the upstream **DumbDo** project.

## 1. Upstream application — DumbDo

- Project: <https://github.com/DumbWareio/DumbDo>
- Author / brand: **DumbWare** (DumbWareio)
- Upstream version: package version `1.0.0`; the image was built from the
  upstream `main` branch at commit `d4dff81e4e` (2025-12-30), the latest
  upstream commit at the time of this package
- Licence: **GNU General Public License v3.0 (GPL-3.0)** —
  <https://github.com/DumbWareio/DumbDo/blob/main/LICENSE>
- Relationship: the upstream application is used **unmodified**, inside the
  container image. No upstream source code is redistributed by this package;
  the image is pulled from Docker Hub at install time.

## 2. Container image — `moechz/dumbdo:2026.11.14`

- Registry: Docker Hub — `docker.io/moechz/dumbdo:2026.11.14`
- Manifest digest (linux/amd64, as resolved on the build NAS):
  `sha256:8620f50201af33a6a5f0d494dce970d15e6a7fce27f9152285010ec8f5ac4bb8`
  The tag is multi-architecture; the aarch64 image resolves to a different
  manifest digest of the same build.
- Maintainer: Moechz — a republished copy of the upstream image, so that the
  package can follow the TOS “Docker Hub only, fixed tag” rule.
- The image is pulled from Docker Hub at install time and is not redistributed
  in this repository or in the package archive.

## 3. Components inside the image

- Base: `node:20.19.6-alpine3.23.2` (Node.js 20.19.6, Alpine Linux 3.23.2).
- Runtime npm dependencies declared by upstream: `express`, `cors`,
  `cookie-parser` and `dotenv`; upstream also uses `sharp` for icon generation
  and `http-server` as a development dependency.
- Each component keeps its own licence inside the image (`node_modules`);
  their notices are not duplicated here. No separate binary is redistributed
  by this package.
- Alpine packages (musl, OpenSSL, wget, etc.) keep the Alpine licence terms.

## 4. This packaging

The files authored for this package — `docker-compose.yml`, `config.ini`,
`dumbdodocker.lang`, `dumbdodocker.svg`, `entrypoint.sh`, the build scripts and
this documentation — are released under **MIT** (see `LICENSE`). The upstream
application and the image remain under **GPL-3.0**; nothing in this packaging
changes that.

## 5. Trademarks and branding

“DumbDo”, “DumbWare” and the DumbDo logo are trademarks or brand names of the
upstream authors. “TerraMaster” and “TOS” are trademarks or registered
trademarks of TerraMaster. Their use in this repository is **descriptive only**
(to identify the upstream project and the target platform).

This package is an independent community submission by Moechz. It is **not
affiliated with, sponsored or endorsed by** the DumbDo/DumbWare project or
TerraMaster.

The icon in `src/dumbdodocker.svg` is a generic rounded tile with a check mark,
drawn for this package. It does not reproduce the upstream DumbDo logo.

## 6. No warranty

The packaging is provided “as is”, without warranty of any kind. The upstream
GPL-3.0 terms apply to the application itself.

## 7. Contact

Moechz — moechz@163.com — <https://www.moechz.com/>
