#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing .env. Run: cp .env.example .env && edit .env"
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

INSTALL_ROOT="${INSTALL_ROOT:-/opt/dify-sqlbot}"
DIFY_DIR="${DIFY_DIR:-$INSTALL_ROOT/dify}"
SQLBOT_DATA_ROOT="${SQLBOT_DATA_ROOT:-$INSTALL_ROOT/sqlbot/data}"
DIFY_PORT="${DIFY_PORT:-8088}"
DOCKER_HOST_BRIDGE_IP="${DOCKER_HOST_BRIDGE_IP:-172.17.0.1}"
SSRF_PROXY_ALLOW_PRIVATE_IPS="${SSRF_PROXY_ALLOW_PRIVATE_IPS:-$DOCKER_HOST_BRIDGE_IP/32}"

if [[ "${SQLBOT_PASSWORD:-}" == "" || "${SQLBOT_PASSWORD:-}" == *"<"* ]]; then
  echo "Set SQLBOT_PASSWORD in .env before running install.sh"
  exit 1
fi

echo "[1/7] Installing Docker and basic tools"
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-v2 git curl
sudo systemctl enable --now docker

echo "[2/7] Creating directories"
sudo mkdir -p "$INSTALL_ROOT"
sudo chown -R "$USER":"$USER" "$INSTALL_ROOT"
mkdir -p "$SQLBOT_DATA_ROOT/sqlbot/excel" \
  "$SQLBOT_DATA_ROOT/sqlbot/file" \
  "$SQLBOT_DATA_ROOT/sqlbot/images" \
  "$SQLBOT_DATA_ROOT/sqlbot/logs" \
  "$SQLBOT_DATA_ROOT/postgresql"

echo "[3/7] Fetching Dify"
if [[ ! -d "$DIFY_DIR/.git" ]]; then
  git clone --depth 1 https://github.com/langgenius/dify.git "$DIFY_DIR"
else
  echo "Dify already exists: $DIFY_DIR"
fi

cd "$DIFY_DIR/docker"

echo "[4/7] Preparing Dify .env"
if [[ ! -f .env ]]; then
  cp .env.example .env
fi

perl -0pi -e "s/^EXPOSE_NGINX_PORT=.*/EXPOSE_NGINX_PORT=$ENV{DIFY_PORT}/m" .env
if grep -q '^SSRF_PROXY_ALLOW_PRIVATE_IPS=' .env; then
  perl -0pi -e "s|^SSRF_PROXY_ALLOW_PRIVATE_IPS=.*|SSRF_PROXY_ALLOW_PRIVATE_IPS=$ENV{SSRF_PROXY_ALLOW_PRIVATE_IPS}|m" .env
else
  printf '\nSSRF_PROXY_ALLOW_PRIVATE_IPS=%s\n' "$SSRF_PROXY_ALLOW_PRIVATE_IPS" >> .env
fi

echo "[5/7] Installing SQLBot compose extension"
cp "$SCRIPT_DIR/docker-compose.sqlbot.yaml" "$DIFY_DIR/docker/docker-compose.sqlbot.yaml"
cp "$ENV_FILE" "$DIFY_DIR/docker/.env.sqlbot"
rm -rf "$DIFY_DIR/docker/sqlbot-dify-mcp"
cp -R "$SCRIPT_DIR/sqlbot-dify-mcp" "$DIFY_DIR/docker/sqlbot-dify-mcp"

echo "[6/7] Pulling base images"
sudo docker compose \
  --env-file .env \
  --env-file .env.sqlbot \
  -f docker-compose.yaml \
  -f docker-compose.sqlbot.yaml \
  pull --ignore-buildable

echo "[7/7] Starting stack"
sudo docker compose \
  --env-file .env \
  --env-file .env.sqlbot \
  -f docker-compose.yaml \
  -f docker-compose.sqlbot.yaml \
  up -d --build

echo
echo "Deployment started. Check status:"
echo "  cd $DIFY_DIR/docker"
echo "  sudo docker compose --env-file .env --env-file .env.sqlbot -f docker-compose.yaml -f docker-compose.sqlbot.yaml ps"
echo
echo "Access URLs:"
echo "  Dify:   http://<SERVER_IP>:$DIFY_PORT"
echo "  SQLBot: http://<SERVER_IP>:${SQLBOT_WEB_PORT:-8000}"
echo
echo "Internal URLs:"
echo "  SQLBot MCP Adapter: http://$DOCKER_HOST_BRIDGE_IP:${SQLBOT_DIFY_MCP_PORT:-8017}/mcp"
echo "  Local PG proxy:      $DOCKER_HOST_BRIDGE_IP:${PG_LOCAL_PROXY_PORT:-15432}"
