# dumbdo-for-tos

> TerraMaster TOS 7 App Center — **Docker application** package for
> [DumbDo](https://github.com/DumbWareio/DumbDo), a minimal self-hosted todo
> list.

## What this is

A four-file TOS Docker application archive (`dumbdodocker.tar.gz`) that installs
DumbDo on TOS 7 through the App Center:

- `config.ini` — TOS application metadata (`application_type: docker`, id `dumbdodocker`)
- `dumbdodocker.lang` — 23-language superset (TOS requires 14)
- `dumbdodocker.svg` — application icon (SVG, rounded tile, 73.4% glyph)
- `docker-compose.yml` — one service, image `moechz/dumbdo:2026.11.14`

The repository also contains the complete source of the package: the `src/`
templates, the deterministic build scripts, the review-standards self-check and
the isolated staging test.

## How it works

| | |
|---|---|
| Container image | `moechz/dumbdo:2026.11.14` (Docker Hub, upstream image used unmodified) |
| Open | `http://<NAS-IP>:8163/` (container port 3000) |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/data` → `/Volume1/DockerAppData/dumbdodocker/data` |
| Data file | `/Volume1/DockerAppData/dumbdodocker/data/todos.json` |
| Logs | `docker logs dumbdodocker` (stdout/stderr) |
| Optional PIN | set `DUMBDO_PIN` (4–10 characters) in the app environment |
| Optional single list | set `SINGLE_LIST=true` |
| Optional title | set `DUMBDO_SITE_TITLE` |

DumbDo itself is a deliberately simple todo list: several named lists, tasks
that can be ticked off, drag-and-drop ordering, “clear completed”, a light/dark
theme, an installable PWA with offline caching, a small JSON API, and an
optional PIN gate. It is **single-user**: there are no accounts, no sharing, no
attachments and no cloud service.

## Repository layout

```text
.
├── README.md                  this file
├── CHANGELOG.md               every published version and its review fixes
├── PRIVACY.md                 privacy policy (also the package `help` target)
├── NOTICE.md                  upstream licence, image source, trademarks
├── LICENSE                    MIT licence for this packaging
├── tosapp.json                app spec read by the build (id, version, image,
│                              port, volume, translations, licences)
├── src/
│   ├── config.ini             TOS metadata template (@@VERSION@@/@@PLATFORM@@)
│   ├── docker-compose.yml     one non-root service, fixed image tag
│   ├── entrypoint.sh          start-up wrapper embedded into the compose file
│   ├── dumbdodocker.lang      23-language descriptions
│   └── dumbdodocker.svg       store icon
├── scripts/
│   ├── build.sh               stage → verify → deterministic tar.gz + sha256
│   └── build-dual.sh          build both architectures and run the official -c
├── tools/
│   └── verify.py              review-standards self-check (archive layout,
│                              metadata, languages, ports, permissions, …)
├── test/
│   └── install-and-verify.sh  optional on-device install check
└── TOSAppSelfTestingTool      official TOS package checker (v1.0.2+)
```

`build/`, `out/` and `test/compose-resolved/` are generated and intentionally
not committed.

## Install, first start and upgrade

1. Install “DumbDo” from App Center, or install the package manually and open
   `http://<NAS-IP>:8163/`.
2. The first start creates `/Volume1/DockerAppData/dumbdodocker/data/todos.json`
   with an empty list. Nothing is downloaded except the Docker image.
3. Tasks are saved immediately through `POST /api/todos`. Restarting or
   updating the app keeps them.
4. **Upgrading from 2026.11.14-2:** that version copied the whole application
   into `/data/app` and stored todos in `/data/app/data/todos.json`. The new
   entrypoint copies that file to `/data/todos.json` once, then removes the
   stale copy. Existing tasks are preserved; the old folder can no longer grow.
5. Back up `todos.json` before uninstalling with “delete data”.

## Privacy

The application runs entirely on your NAS. **The developer does not collect,
receive or have access to any data.** There is no telemetry, no analytics, no
account and no update check. The app contacts only the Docker registry (image
pull) and the browser that uses the UI; no third-party service is embedded.

| Topic | Detail |
|---|---|
| Data processed | List names, task text, completion state and order; optional PIN environment setting; theme in browser `localStorage`. |
| Where it is stored | `/Volume1/DockerAppData/dumbdodocker/data/todos.json` on your NAS. |
| Retention | Until **you** delete it. Uninstalling keeps the folder unless “delete data” is ticked. |
| Your rights | **Access/export**: open the UI, `GET /api/todos`, or copy the JSON file. **Correct**: edit in the UI. **Delete**: delete in the UI or remove the data folder. |
| Deletion channel | Remove the folder after stopping the app, or email **moechz@163.com** (answered within 30 days). |
| Security | Non-root uid 1000, no `privileged`, no host network, no `cap_add`, no Docker socket, one published port, fixed image tag. Optional PIN gate. |

**Full policy:** [PRIVACY.md](PRIVACY.md) —
<https://github.com/Moechz/dumbdo/blob/main/PRIVACY.md>. The package `help`
field and `config.ini` point to that URL.

## Security and known limitations

- **LAN exposure:** the web UI is plain HTTP and has no accounts. Without
  `DUMBDO_PIN`, anyone who can reach port 8163 can read and change the lists.
  Use a VPN or a TLS reverse proxy on untrusted networks; do not expose the
  port to the internet.
- **PIN is not encryption:** the PIN gates the UI/API and is kept in an
  HttpOnly cookie; it does not encrypt `todos.json` on disk.
- **T1 (upstream CVE):** the review flagged a high/critical vulnerability in the
  upstream image. Upstream has published no newer source commit, tag or image
  after 2025-12-30 (`d4dff81e4e`), and the mirrored image `moechz/dumbdo:2026.11.14`
  is that same build. There is therefore no newer upstream image to move to.
  The item is tracked in [CHANGELOG.md](CHANGELOG.md) and will be re-checked on
  every upstream release; the packaging itself cannot patch the runtime
  dependencies without forking the image. Keep the app on the LAN and update as
  soon as upstream publishes a fixed image.
- **Upstream licence:** DumbDo is **GPL-3.0**. See [NOTICE.md](NOTICE.md) for
  attribution, image provenance and the trademark statement.

## Build and verification

```bash
scripts/build.sh                  # -> out/dumbdodocker.tar.gz + .sha256
scripts/build.sh 2026.11.14-3 x86_64
scripts/build-dual.sh 2026.11.14-3   # both architectures + official -c
python3 ../../stage.py .              # isolated runtime check (from issue-watch)
```

The build stages the four files, substitutes `@@VERSION@@`/`@@PLATFORM@@`,
injects `src/entrypoint.sh` into the compose block scalar (escaping `$`),
removes CRLF/BOM/AppleDouble, then runs `tools/verify.py`: archive layout, JSON
validity, required fields, 14+ language coverage, version consistency,
Docker-Hub-only images, fixed tag, reserved/recommended host ports, non-root
user, per-service healthcheck/TZ/restart, data path below the application data
root, never the `/Volume*` wildcard, no literal secrets, the SVG size/element
limits and the 73.4% icon glyph. `scripts/build-dual.sh` then runs the official
`TOSAppSelfTestingTool -c` on both packages.

## Licence and attributions

| Component | Licence | Notes |
|---|---|---|
| DumbDo (upstream) | **GPL-3.0** | <https://github.com/DumbWareio/DumbDo> — used unmodified inside the image |
| `moechz/dumbdo` image | GPL-3.0 | Docker Hub mirror of the upstream build, pulled at install time |
| This packaging (compose, metadata, translations, icon, scripts) | MIT | see `LICENSE` |

“DumbDo”, “DumbWare”, “TerraMaster” and “TOS” are trademarks or registered
trademarks of their respective owners. This is an independent community package
by Moechz; it is not affiliated with or endorsed by the DumbDo project or
TerraMaster. Full details: [NOTICE.md](NOTICE.md).

## Support

- Privacy and packaging: **moechz@163.com**
- Upstream application: <https://github.com/DumbWareio/DumbDo/issues>
