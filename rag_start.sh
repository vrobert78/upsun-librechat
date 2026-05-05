#!/bin/bash
set -euo pipefail

mkdir -p /app/uploads /app/hf-cache

# Map Upsun PostgreSQL relationship env vars to what rag_api expects
export DB_HOST="${POSTGRES_HOST}"
export DB_PORT="${POSTGRES_PORT}"
export POSTGRES_USER="${POSTGRES_USERNAME}"
export POSTGRES_DB="${POSTGRES_PATH}"
# POSTGRES_PASSWORD is already injected with the right name

# rag_api verifies LibreChat request tokens using the same JWT secret.
# JWT_SECRET is set as a project-level variable so both apps can access it.
export RAG_JWT_SECRET="${JWT_SECRET}"

# Run from the cloned rag_api directory so relative imports (app.*) resolve
cd /app/.rag_api

exec python -m uvicorn main:app --host 0.0.0.0 --port "${PORT}" --workers 1
