#!/bin/sh
# ===========================================================================
# TOS wrapper for DumbDo.
# ===========================================================================
# The upstream image may be built with /app owned by root, so a non-root
# container cannot write into the image tree. DumbDo only writes its data/
# directory and the generated PWA assets under public/assets, so copy the
# small application code (server.js, package.json, scripts/, public/) into
# /data/app and reuse the image's node_modules through a symlink. Copying the
# full ~250 MB application tree on first start is what made the aarch64
# installation test time out; that copy is gone.
#
# Data written by 2026.11.14-2 lived in /data/app/data/todos.json because that
# version ran a full copy of the app from the volume. Migrate it once, then
# point the app's data directory at the volume root.
# ===========================================================================
set -u
set -e

mkdir -p /data/app

if [ -f /data/app/data/todos.json ] && [ ! -f /data/todos.json ]; then
  cp /data/app/data/todos.json /data/todos.json
fi

cp /app/server.js /app/package.json /data/app/
rm -rf /data/app/scripts /data/app/public
cp -R /app/scripts /data/app/scripts
cp -R /app/public /data/app/public
rm -rf /data/app/node_modules
ln -s /app/node_modules /data/app/node_modules

# server.js resolves its data directory relative to the application root.
rm -rf /data/app/data
ln -s /data /data/app/data

cd /data/app
exec node server.js
