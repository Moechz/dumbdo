# Changelog

All notable user-visible changes to the DumbDo TOS application package.

## 2026.11.14-3 — 2026-11-21

Remediation of the aarch64 App Listing Review on-hold notice for
`2026.11.14-2` (tracking number `TOS-APP-CL-20261120-01`, codes
C10/C2/C3/C9/T1 plus runtime item F2). The upstream image stays at
`moechz/dumbdo:2026.11.14` because upstream has no newer build.

### Added
- **Privacy policy** (`PRIVACY.md`): what is stored locally (todo lists, no
  accounts, no attachments), where it is stored, the absence of outbound
  traffic and third-party sharing, retention, user rights, security measures
  and the deletion channel. The package `help` field and `config.ini` now point
  to <https://github.com/Moechz/dumbdo/blob/main/PRIVACY.md> (C3).
- **Licence notice** (`NOTICE.md`): upstream DumbDo is GPL-3.0 (the previous
  package metadata incorrectly said MIT), the image tag and amd64 manifest
  digest, the upstream commit the image was built from, the components inside
  the image, and the trademark/branding statement that the DumbDo name and
  brand belong to the upstream authors (C2).
- **Complete source repository and README** (`README.md`): what the package
  is, how it works, the full repository layout, install/upgrade notes, privacy
  summary, security limitations, build and verification commands, and licence
  and attribution tables. The repository previously contained only an
  eight-byte README (C10).
- `LICENSE` (MIT) for the packaging files; the upstream application remains
  GPL-3.0.

### Fixed
- **F2 — service failed to start / installation test could not open the app.**
  The `2026.11.14-2` entrypoint copied the whole 254 MB image tree into
  `/data/app` on first start and then ran `npm start` from there. On slower
  aarch64 hardware that copy took longer than the install test allowed, so the
  service was not ready when the reviewer checked it. The wrapper now runs the
  application in place as uid 1000, mounts only `/data` for the JSON file, and
  no longer copies `node_modules` at start-up. Existing todos written by
  `2026.11.14-2` at `/data/app/data/todos.json` are migrated to
  `/data/todos.json` once, then the stale copy is removed.
- **C9 — description inconsistent with delivered functionality.** The English
  description now lists the features DumbDo 1.0.0 actually ships (multiple
  lists, tasks, completion, drag-and-drop order, clear completed, PWA/offline,
  optional PIN, JSON API) instead of a generic one-line summary. The
  Simplified and Traditional Chinese descriptions and installation notes were
  leftover text from a different application (a habit tracker) and have been
  rewritten to describe DumbDo, its data file and its optional PIN. All 23
  language sections carry the corrected release note; the package notes no
  longer claim the first start copies the application into the data volume.
- **C2 licence metadata.** `tosapp.json` now declares GPL-3.0 for the upstream
  application and its packaging instead of the incorrect MIT value.
- Stale build metadata in `tosapp.json` (an `entrypoint_file` pointing to a
  file that is not part of this repository, and a probe block for another
  application) was removed; the spec now matches the files that are actually
  built.

### Security
- **T1 — high/critical CVE in the upstream image, retained with reason.** The
  upstream DumbDo repository has no release, tag or commit newer than
  `d4dff81e4e` (2025-12-30), and the mirrored image `moechz/dumbdo:2026.11.14`
  is that build (Node.js 20.19.6 on Alpine 3.23.2). There is no newer upstream
  image to upgrade to, and the packaging does not redistribute or rebuild the
  application, so the affected runtime components cannot be patched from this
  repository without forking the upstream image. The finding remains tracked:
  it will be re-checked on the next upstream release, and the package will be
  rebuilt on the fixed image as soon as one exists. Mitigations available to
  users today: keep the app on the LAN, do not expose port 8163, and set
  `DUMBDO_PIN`.

### Changed
- Version bumped from `2026.11.14-2` to `2026.11.14-3` (upstream base
  unchanged).
- The compose healthcheck keeps the same command and timing; the start-up work
  no longer depends on copying the image tree.

## 2026.11.14-2 — 2026-11-14

Initial App Center release: DumbDo running from the mirrored upstream image
`moechz/dumbdo:2026.11.14`, non-root container, persistent `todos.json` in
`/Volume1/DockerAppData/dumbdodocker/data`, 23-language metadata.
