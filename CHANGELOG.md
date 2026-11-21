# Changelog

All notable user-visible changes to the DumbDo TOS application package.

## 2026.11.14-4 — 2026-11-21

Supersedes `2026.11.14-3` before the aarch64 review completed. Same review
findings (C10/C2/C3/C9/F2/T1), plus the architecture root cause found while
validating `2026.11.14-3`.

### Fixed
- **F2 — aarch64 service failed to start: amd64-only image.** The
  `2026.11.14-2` and `2026.11.14-3` packages used
  `moechz/dumbdo:2026.11.14`, which is a **single `linux/amd64` OCI manifest**
  (verified against the registry). On aarch64 hardware the container cannot
  execute, so the service never becomes ready and the install test cannot open
  the app. This version pulls the official upstream
  `dumbwareio/dumbdo:d4dff81e4eab16de0974a94742e1cd3bc51a369a`, an OCI image
  index with native `linux/amd64` (`sha256:8620f502…`) and `linux/arm64`
  (`sha256:8b59120d…`) manifests.
- **F2 — first-start copy removed.** The wrapper now copies only
  `server.js`, `package.json`, `scripts/` and `public/` (a few hundred KB) into
  `/data/app` and symlinks `node_modules` from the image. It no longer copies
  the ~250 MB dependency tree on first start. Todos from the old layout
  (`/data/app/data/todos.json`) are migrated to `/data/todos.json`.

### Added
- **Privacy policy** (`PRIVACY.md`): what is stored locally (todo lists; no
  accounts, no attachments), the data file, the absence of outbound traffic and
  third-party sharing, retention, user rights, security measures and the
  deletion channel. The package `help` field and `config.ini` point to
  <https://github.com/Moechz/dumbdo/blob/main/PRIVACY.md> (C3).
- **Licence notice** (`NOTICE.md`): upstream DumbDo is GPL-3.0 (the earlier
  package metadata incorrectly said MIT), the official image tag, both
  architecture digests, the upstream commit, the components inside the image,
  and the trademark/branding statement that the DumbDo name and brand belong to
  the upstream authors (C2).
- **Complete source repository and README** (`README.md`): what the package is,
  how it works, the full repository layout, install/upgrade notes, privacy
  summary, security limitations, build and verification commands, licence and
  attribution tables. The repository previously contained only an eight-byte
  README (C10).
- `LICENSE` (MIT) for the packaging files; the upstream application remains
  GPL-3.0.

### Fixed (continued)
- **C9 — description inconsistent with delivered functionality.** The English
  description now lists what DumbDo 1.0.0 actually ships (multiple lists, tasks,
  completion, drag-and-drop order, clear completed, PWA/offline, optional PIN,
  JSON API). The Simplified and Traditional Chinese descriptions and install
  notes were leftover text from a different application (a habit tracker) and
  now describe DumbDo, its data file and its optional PIN. All 23 language
  sections carry the corrected release note.
- **C2 licence metadata.** `tosapp.json` declares GPL-3.0 for the upstream
  application instead of the incorrect MIT value.
- Stale build metadata in `tosapp.json` (an `entrypoint_file` pointing to a
  file outside this repository and a probe block for another application) was
  removed; the spec now matches the files that are built.

### Security
- **T1 — high/critical CVE in the upstream image, retained with reason.** The
  upstream DumbDo repository has no release, tag or commit newer than
  `d4dff81e4e` (2025-12-30); the official multi-arch image pinned above is that
  build (Node.js 20.19.6 on Alpine 3.23.2). There is no newer upstream image to
  upgrade to, and the packaging does not redistribute or rebuild the
  application, so the affected runtime components cannot be patched from this
  repository without forking the upstream image. The finding remains tracked:
  it will be re-checked on the next upstream release, and the package will be
  rebuilt on the fixed image as soon as one exists. Mitigations available today:
  keep the app on the LAN, do not expose port 8163, and set `DUMBDO_PIN`.

### Changed
- Version bumped from `2026.11.14-3` to `2026.11.14-4` (upstream base
  unchanged).
- Image tag changed from the maintainer's amd64-only mirror to the official
  upstream multi-arch commit tag.

## 2026.11.14-3 — 2026-11-21 (withdrawn)

**Superseded by `2026.11.14-4` before the aarch64 review completed.** This
build introduced the privacy policy, the licence notice, the complete README
and the corrected descriptions, but still used the maintainer's
`moechz/dumbdo:2026.11.14` mirror, which is a single `linux/amd64` manifest.
The aarch64 package therefore could not start on arm64 hardware. The GitHub
release remains in the history, but the store version was withdrawn and
replaced by `2026.11.14-4`.

### Added
- `PRIVACY.md`, `NOTICE.md`, `LICENSE`, the complete source tree and README.
- Metadata corrections for C2/C9/C10 and the package `help` link for C3.
- A start-up wrapper that no longer ran from the full copy of the app.

### Withdrawn because
- F2 was not fully fixed: the container image itself was amd64-only.

## 2026.11.14-2 — 2026-11-14

Initial App Center release: DumbDo running from the mirrored upstream image
`moechz/dumbdo:2026.11.14`, non-root container, persistent `todos.json` in
`/Volume1/DockerAppData/dumbdodocker/data`, 23-language metadata.
