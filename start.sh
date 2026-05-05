#!/bin/bash
set -euo pipefail

# Ensure writable directories exist
mkdir -p /app/mongodb/data /app/mongodb/logs
mkdir -p /app/librechat/logs /app/librechat/uploads /app/librechat/images

# Start MongoDB in the background.
# --bind_ip 127.0.0.1  : listen on loopback only — no external exposure
# --wiredTigerCacheSizeGB 0.25 : cap RAM usage for a small container
mongod \
  --dbpath /app/mongodb/data \
  --logpath /app/mongodb/logs/mongod.log \
  --bind_ip 127.0.0.1 \
  --port 27017 \
  --wiredTigerCacheSizeGB 0.25 &

MONGOD_PID=$!

echo "Waiting for MongoDB to be ready..."
until mongosh --quiet --eval "db.adminCommand('ping')" "mongodb://127.0.0.1:27017" >/dev/null 2>&1; do
  if ! kill -0 "$MONGOD_PID" 2>/dev/null; then
    echo "mongod exited unexpectedly. Check /app/mongodb/logs/mongod.log" >&2
    exit 1
  fi
  sleep 1
done
echo "MongoDB is ready."

# Change to the writable mount so that LibreChat's relative upload/image paths
# (patched by the Nix package to be CWD-relative) land in a writable location.
cd /app/librechat

# $PORT is set by Upsun; LibreChat reads it as process.env.PORT automatically.
exec librechat-server
