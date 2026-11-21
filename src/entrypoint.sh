#!/bin/sh
# ===========================================================================
# TOS wrapper for DumbDo.
# ===========================================================================
# The upstream image ships /app owned by uid 1000 and expects to write only
# its own data/ directory and the generated PWA assets under public/assets.
# TOS forbids a root container, so this wrapper starts the application in
# place as uid 1000 and points data/ at the persistent volume instead of
# copying the whole application tree (about 250 MB) on first start. The copy
# made the aarch64 installation test time out before the service became
# ready, which is the start-up failure reported in the review.
#
# Data written by 2026.11.14-2 lived in /data/app/data/todos.json because that
# version ran a full copy of the app from the volume. Migrate it once, then
# remove the stale copy so it does not occupy the volume twice.
# ===========================================================================
set -u
set -e

mkdir -p /data

if [ -d /data/app ]; then
  if [ -f /data/app/data/todos.json ] && [ ! -f /data/todos.json ]; then
    cp /data/app/data/todos.json /data/todos.json
  fi
  rm -rf /data/app
fi

# server.js resolves its data directory relative to the application root.
rm -rf /app/data
ln -s /data /app/data

cd /app
exec node server.js
