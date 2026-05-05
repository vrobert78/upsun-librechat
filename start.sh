#!/bin/bash
set -euo pipefail

# Ensure writable directories exist
mkdir -p /app/librechat/logs /app/librechat/uploads /app/librechat/images

# Build MONGO_URI from relationship env vars injected by Upsun.
# These come from the 'mongodb' relationship defined in .upsun/config.yaml.
export MONGO_URI="${MONGODB_SCHEME}://${MONGODB_USERNAME}:${MONGODB_PASSWORD}@${MONGODB_HOST}:${MONGODB_PORT}/${MONGODB_PATH}"

# Change to the writable mount so that LibreChat's relative upload/image paths
# (patched by the Nix package to be CWD-relative) land in a writable location.
cd /app/librechat

# $PORT is set by Upsun; LibreChat reads it as process.env.PORT automatically.
exec librechat-server
