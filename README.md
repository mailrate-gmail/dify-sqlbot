# Dify + SQLBot One-Command Deployment Package

This repository deploys a Dify + SQLBot lab stack on a blank Ubuntu VM.

It includes:

- Dify official Docker Compose stack
- SQLBot Docker container
- SQLBot-to-Dify MCP adapter
- Local PostgreSQL bridge proxy for SQLBot datasource access

## 1. Prerequisites

- Ubuntu 24.04 or compatible Linux VM
- Public ports available:
  - `8088` for Dify
  - `8000` for SQLBot
- Internet access to GitHub, Docker Hub, and PyPI for first-time installation.

## 2. Adapter Image

By default, the target VM builds `sqlbot-dify-mcp` locally from source under:

```text
./sqlbot-dify-mcp
```

No custom Docker Hub image is required.

Optional: if your target VM cannot access PyPI or you want faster installs, build and push the adapter image first:

```bash
./push-image.sh docker.io/<user>/sqlbot-dify-mcp 1.0.0
```

Then override this in `.env`:

```env
SQLBOT_DIFY_MCP_IMAGE=docker.io/<user>/sqlbot-dify-mcp:1.0.0
```

## 3. Deploy on Blank VM

```bash
sudo apt-get update
sudo apt-get install -y git curl

git clone https://github.com/mailrate-gmail/dify-sqlbot.git
cd dify-sqlbot

cp .env.example .env
vim .env

sudo bash install.sh
```

Required `.env` values:

```env
SQLBOT_PASSWORD=<SQLBot admin password used by adapter>
```

## 4. Access

```text
Dify:   http://<SERVER_IP>:8088
SQLBot: http://<SERVER_IP>:8000
```

## 5. SQLBot Datasource for Local PostgreSQL

If the business PostgreSQL is on the VM and listens on `127.0.0.1:5432`, use this in SQLBot:

```text
Host: 172.17.0.1
Port: 15432
Database: sales_management
Username: sales_app
Password: <database password>
Schema: business
```

`pg-local-proxy` maps:

```text
172.17.0.1:15432 -> 127.0.0.1:5432
```

It is not exposed to the public network.

## 6. Import Demo Business Data

This repository includes demo data exported from the `business` schema:

```text
seed/business_data.sql
```

Import it into an existing PostgreSQL database after the full application schema has been created.

If the target PostgreSQL uses password authentication over TCP:

```bash
DB_HOST=127.0.0.1 \
DB_PORT=5432 \
DB_NAME=sales_management \
DB_USER=postgres \
DB_PASSWORD=<postgres-password-if-needed> \
RESET_BUSINESS_DATA=true \
./scripts/import_business_data.sh
```

If the target PostgreSQL is local and uses peer authentication for the `postgres` OS user:

```bash
sudo -u postgres \
  DB_HOST=/var/run/postgresql \
  DB_PORT=5432 \
  DB_NAME=sales_management \
  DB_USER=postgres \
  RESET_BUSINESS_DATA=true \
  ./scripts/import_business_data.sh
```

Notes:

- The import script defaults to schema `business`.
- The SQL file is data-only. The target database must already have the required schemas, tables, functions, and constraints.
- `RESET_BUSINESS_DATA=true` truncates all tables in the `business` schema before import.
- The script uses `session_replication_role=replica` to handle circular foreign keys, so it should be run with a PostgreSQL superuser such as `postgres`.

## 7. Dify MCP Configuration

In Dify, add MCP Server:

```text
Name: SQLBot MCP Demo
Server Identifier: sqlbot_mcp
Server URL: http://172.17.0.1:8017/mcp
```

Expected tools:

```text
sqlbot_ask
sqlbot_datasource_list
```

## 8. Dify Workflow Demo

Create a Workflow app:

```text
Start -> SQLBot MCP Tool -> End
```

Start input:

```text
question: paragraph, required
```

Tool:

```text
SQLBot MCP Demo / sqlbot_ask
question = start.question
datasource_id = 1
return_img = false
```

End:

```text
result = SQLBot tool node.text
```

Example question:

```text
基于 payment 表，按 customer_id 统计 amount 总和，查询总金额最高的前5个客户，返回 customer_id 和 total_amount
```

The adapter returns Markdown with:

- table
- ECharts code block
- generated SQL

## 9. Operations

```bash
cd /opt/dify-sqlbot/dify/docker

sudo docker compose --env-file .env --env-file .env.sqlbot \
  -f docker-compose.yaml -f docker-compose.sqlbot.yaml ps

sudo docker logs -f sqlbot
sudo docker logs -f sqlbot-dify-mcp
```

Stop stack:

```bash
sudo docker compose --env-file .env --env-file .env.sqlbot \
  -f docker-compose.yaml -f docker-compose.sqlbot.yaml stop
```

Start stack:

```bash
sudo docker compose --env-file .env --env-file .env.sqlbot \
  -f docker-compose.yaml -f docker-compose.sqlbot.yaml up -d --build
```

## 10. Security Notes

Do not expose these ports publicly:

- `8001`
- `8017`
- `15432`
- `5432`
- `5003`

Do not commit `.env` to Git.
