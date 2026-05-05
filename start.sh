#!/bin/bash
set -euo pipefail

mkdir -p /app/librechat/logs /app/librechat/uploads /app/librechat/images

# Build MONGO_URI from relationship env vars injected by Upsun
export MONGO_URI="${MONGODB_SCHEME}://${MONGODB_USERNAME}:${MONGODB_PASSWORD}@${MONGODB_HOST}:${MONGODB_PORT}/${MONGODB_PATH}"

# Build RAG_API_URL from the app-to-app relationship (rag_api: "rag-api:http")
export RAG_API_URL="${RAG_API_SCHEME}://${RAG_API_HOST}:${RAG_API_PORT}"

# Change to the writable mount so that LibreChat's relative upload/image paths
# (patched by the Nix package to be CWD-relative) land in a writable location
cd /app/librechat

exec librechat-server
