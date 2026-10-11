#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-sales_management}"
DB_USER="${DB_USER:-postgres}"
DB_SCHEMA="${DB_SCHEMA:-business}"
SQL_FILE="${SQL_FILE:-$REPO_ROOT/seed/business_schema_and_data.sql}"
RESET_BUSINESS_DATA="${RESET_BUSINESS_DATA:-false}"

if [[ ! -f "$SQL_FILE" ]]; then
  echo "SQL file not found: $SQL_FILE"
  exit 1
fi

tmp_sql="$(mktemp)"
trap 'rm -f "$tmp_sql"' EXIT

cat >"$tmp_sql" <<SQL
\set ON_ERROR_STOP on
SET session_replication_role = replica;
SQL

if [[ "$RESET_BUSINESS_DATA" == "true" ]]; then
  cat >>"$tmp_sql" <<SQL
DO \$\$
DECLARE
  stmt text;
BEGIN
  SELECT 'TRUNCATE TABLE ' || string_agg(format('%I.%I', schemaname, tablename), ', ') || ' RESTART IDENTITY CASCADE'
    INTO stmt
  FROM pg_tables
  WHERE schemaname = '${DB_SCHEMA}';
  IF stmt IS NOT NULL THEN
    EXECUTE stmt;
  END IF;
END
\$\$;
SQL
fi

cat >>"$tmp_sql" <<SQL
\i $SQL_FILE
SET session_replication_role = origin;
SQL

echo "Importing $SQL_FILE into $DB_NAME.$DB_SCHEMA via $DB_HOST:$DB_PORT as $DB_USER"
if [[ "$RESET_BUSINESS_DATA" == "true" ]]; then
  echo "RESET_BUSINESS_DATA=true, existing $DB_SCHEMA tables will be truncated first."
fi

PGPASSWORD="${DB_PASSWORD:-}" psql \
  -h "$DB_HOST" \
  -p "$DB_PORT" \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -f "$tmp_sql"

echo "Import completed."
