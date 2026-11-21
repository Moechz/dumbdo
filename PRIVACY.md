# Privacy Policy — DumbDo for TerraMaster TOS (`dumbdodocker`)

**Last updated:** 21 November 2026
**Data controller / contact:** Moechz — moechz@163.com
**Applies to:** version `2026.11.14-4` and later of the TOS application
`dumbdodocker`, the container image it runs and this repository.

## 1. Summary

- DumbDo runs **entirely on your NAS**. The developer does not receive, collect
  or have access to your todo lists or any other data.
- There are **no user accounts**, no login service, no telemetry, no analytics
  and no cloud service operated by the developer.
- The application does **not** phone home and does **not** check for updates.
  It only serves the web UI on your LAN and reads/writes one local JSON file.
- The only network access in the normal path is the Docker image pull from
  Docker Hub when the application is installed or updated.

## 2. What data is processed

| Data | Stored on the NAS at |
|---|---|
| Todo lists: list names, task text, completion state, order | `/Volume1/DockerAppData/dumbdodocker/data/todos.json` |
| Optional PIN (only if you set `DUMBDO_PIN`) | Passed to the container as an environment variable by your compose file / TOS app settings; the application does not write it to disk. The browser keeps it in an HttpOnly cookie (`DUMBDO_PIN`) for the session. |
| Theme preference (light/dark) | Your browser's `localStorage`; not sent to the server |
| Container logs (startup messages, generated-asset messages) | stdout/stderr only — `docker logs dumbdodocker`; no log file on the NAS |

There are **no accounts** (no username, password or e-mail address is created or
stored by the app) and **no attachments or file uploads**: DumbDo stores text
tasks only. The generated PWA icons and manifests under `/app/public/assets`
live inside the container and are rebuilt at every start; they are not
persistent data.

If you enable `DUMBDO_SITE_TITLE` or `SINGLE_LIST`, those values are likewise
environment settings and are not personal data collected by the developer.

## 3. Retention period

- **Todo lists and settings:** kept until **you** delete them. There is no
  automatic expiry and no upload.
- **Uninstalling:** stops and removes the container. The data folder is kept
  unless you tick “delete data” in App Center. To delete it yourself, stop the
  app, then remove `/Volume1/DockerAppData/dumbdodocker/`.
- **Logs:** stdout/stderr only; the Docker daemon keeps them according to its
  own rotation settings.
- **Browser data:** the theme preference and service-worker cache stay in your
  browser until you clear site data.

## 4. Network connections and third parties

| Destination | When | Data sent |
|---|---|---|
| `registry-1.docker.io` (Docker Hub) or your configured registry mirror | install and update only | anonymous image pull; no todo data |
| Your browser ↔ NAS on port 8182 | whenever you use the app | the todo lists you create, over plain HTTP on the LAN |
| The developer's servers | never | none |

The application embeds **no** third-party analytics, fonts, CDNs, ads or
tracking pixels. There is **no third-party sharing or sale** of data. If you
place the app behind a reverse proxy, VPN or tunnel that you operate, that
component is outside this package and its own privacy terms apply.

## 5. Your rights

Because all data stays on your NAS, you exercise these rights directly:

- **Access / portability:** open the web UI, call `GET /api/todos`, or copy
  `/Volume1/DockerAppData/dumbdodocker/data/todos.json`.
- **Correction:** edit the task or list name in the web UI.
- **Deletion:** delete tasks/lists in the web UI, or stop the app and remove the
  data folder. Uninstalling with “delete data” in App Center does the same.
- **Restriction / objection:** do not enable the optional PIN and do not expose
  the port outside your LAN; no consent to any developer-side processing is
  required because none takes place.

There is no developer-side account to close and no data to request from the
developer. If you believe the packaging itself mishandles data, contact
**moechz@163.com**; requests are answered within 30 days.

## 6. Security measures

- The container runs as **uid 1000**, never as root, with no `privileged` mode,
  no host network, no `cap_add` and no Docker socket.
- Only one port (8182) is published; the application stores data in a single
  JSON file inside its own data folder.
- The image tag is pinned to the official upstream commit
  (`dumbwareio/dumbdo:d4dff81e4eab16de0974a94742e1cd3bc51a369a`), never
  `:latest`.
- The optional PIN gate (`DUMBDO_PIN`, 4–10 characters) limits casual access.
  It is **off by default**; when off, anyone who can reach port 8182 can read
  and change the lists. The PIN is transmitted in a cookie and is not a
  replacement for transport security.
- The web UI is served over **plain HTTP**. On an untrusted network, put it
  behind a VPN or a reverse proxy with TLS, and do not expose port 8182 to the
  internet.
- Back up `/Volume1/DockerAppData/dumbdodocker/data/todos.json` before
  uninstalling with data removal.

## 7. Children

DumbDo is a general-purpose productivity tool and is not directed at children.
No age or identity data is collected.

## 8. Changes to this policy

Material changes are recorded in `CHANGELOG.md` and in this file's “Last
updated” date. The current version is always available at
<https://github.com/Moechz/dumbdo/blob/main/PRIVACY.md>, which is also the URL
in the package `help` field.

## 9. Contact

Moechz — **moechz@163.com** — <https://www.moechz.com/>
