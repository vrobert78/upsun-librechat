#!/bin/bash
set -euo pipefail

mkdir -p /app/librechat/logs

# Build MONGO_URI from relationship env vars injected by Upsun
export MONGO_URI="${MONGODB_SCHEME}://${MONGODB_USERNAME}:${MONGODB_PASSWORD}@${MONGODB_HOST}:${MONGODB_PORT}/${MONGODB_PATH}"

# Build RAG_API_URL from the app-to-app relationship (rag_api: "rag-api:http")
export RAG_API_URL="${RAG_API_SCHEME}://${RAG_API_HOST}:${RAG_API_PORT}"

cd /app/.librechat
exec node api/server/index.js
