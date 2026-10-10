# Dify + SQLBot 一键部署包

本仓库用于在一台空白 Ubuntu VM 上部署 Dify + SQLBot 实验环境。

包含组件：

- Dify 官方 Docker Compose 服务栈
- SQLBot Docker 容器
- SQLBot 到 Dify 的 MCP 适配器
- 用于 SQLBot 访问本机 PostgreSQL 的本地桥接代理

## 1. 前置条件

- Ubuntu 24.04 或兼容的 Linux VM
- 可用公网端口：
  - `8088`：Dify 控制台
  - `8000`：SQLBot 控制台
- 首次安装时，服务器需要能够访问 GitHub、Docker Hub 和 PyPI。

## 2. 适配器镜像

默认情况下，目标 VM 会从本仓库源码本地构建 `sqlbot-dify-mcp`：

```text
./sqlbot-dify-mcp
```

因此默认不需要提前准备自定义 Docker Hub 镜像。

可选方案：如果目标 VM 无法访问 PyPI，或希望加快安装速度，可以先在其他机器构建并推送适配器镜像：

```bash
./push-image.sh docker.io/<user>/sqlbot-dify-mcp 1.0.0
```

然后在 `.env` 中覆盖镜像地址：

```env
SQLBOT_DIFY_MCP_IMAGE=docker.io/<user>/sqlbot-dify-mcp:1.0.0
```

## 3. 在空白 VM 上部署

```bash
sudo apt-get update
sudo apt-get install -y git curl

git clone https://github.com/mailrate-gmail/dify-sqlbot.git
cd dify-sqlbot

cp .env.example .env
vim .env

sudo bash install.sh
```

`.env` 中必须设置：

```env
SQLBOT_PASSWORD=<适配器调用 SQLBot 使用的管理员密码>
```

## 4. 访问地址

```text
Dify:   http://<SERVER_IP>:8088
SQLBot: http://<SERVER_IP>:8000
```

## 5. SQLBot 连接本机 PostgreSQL 数据源

如果业务 PostgreSQL 与部署服务在同一台 VM 上，并且 PostgreSQL 只监听 `127.0.0.1:5432`，则在 SQLBot 中添加 PostgreSQL 数据源时填写：

```text
Host: 172.17.0.1
Port: 15432
Database: sales_management
Username: sales_app
Password: <database password>
Schema: business
```

`pg-local-proxy` 的转发关系：

```text
172.17.0.1:15432 -> 127.0.0.1:5432
```

该转发只监听 Docker bridge 地址，不会暴露到公网。

## 6. 导入演示业务数据

本仓库包含从 `business` schema 导出的演示数据：

```text
seed/business_data.sql
```

在导入数据前，目标数据库必须已经完成完整应用 schema 初始化。

如果目标 PostgreSQL 通过 TCP 密码认证访问：

```bash
DB_HOST=127.0.0.1 \
DB_PORT=5432 \
DB_NAME=sales_management \
DB_USER=postgres \
DB_PASSWORD=<postgres-password-if-needed> \
RESET_BUSINESS_DATA=true \
./scripts/import_business_data.sh
```

如果目标 PostgreSQL 是本机数据库，并且 `postgres` 操作系统用户使用 peer 认证：

```bash
sudo -u postgres \
  DB_HOST=/var/run/postgresql \
  DB_PORT=5432 \
  DB_NAME=sales_management \
  DB_USER=postgres \
  RESET_BUSINESS_DATA=true \
  ./scripts/import_business_data.sh
```

说明：

- 导入脚本默认操作 `business` schema。
- `seed/business_data.sql` 是纯数据文件。目标数据库必须已存在所需 schema、表、函数和约束。
- `RESET_BUSINESS_DATA=true` 会先清空 `business` schema 下的所有表，再导入演示数据。
- 脚本会使用 `session_replication_role=replica` 处理循环外键，因此建议使用 PostgreSQL 超级用户执行，例如 `postgres`。

## 7. Dify MCP 配置

在 Dify 中新增 MCP Server：

```text
Name: SQLBot MCP Demo
Server Identifier: sqlbot_mcp
Server URL: http://172.17.0.1:8017/mcp
```

授权并刷新后，应看到以下工具：

```text
sqlbot_ask
sqlbot_datasource_list
```

## 8. Dify Workflow 演示应用

本仓库包含已导出的 Dify DSL 应用：

```text
dify-apps/integrated-sqlbot-demo.yml
```

完成 Dify 初始化并配置好 SQLBot MCP Server 后，可以在 Dify 中导入该 DSL，快速创建演示应用。

导入后的应用依赖以下 MCP Server：

```text
Server Identifier: sqlbot_mcp
Tool: sqlbot_ask
```

如果手工创建 Workflow，可参考以下结构。

创建 Workflow 应用：

```text
Start -> SQLBot MCP Tool -> End
```

Start 节点输入：

```text
question: paragraph, required
```

Tool 节点：

```text
SQLBot MCP Demo / sqlbot_ask
question = start.question
datasource_id = 1
return_img = false
```

End 节点：

```text
result = SQLBot tool node.text
```

示例问题：

```text
基于 payment 表，按 customer_id 统计 amount 总和，查询总金额最高的前5个客户，返回 customer_id 和 total_amount
```

适配器返回 Markdown 内容，包含：

- 表格
- ECharts 代码块
- 生成 SQL

## 9. 运维命令

查看服务状态：

```bash
cd /opt/dify-sqlbot/dify/docker

sudo docker compose --env-file .env --env-file .env.sqlbot \
  -f docker-compose.yaml -f docker-compose.sqlbot.yaml ps

sudo docker logs -f sqlbot
sudo docker logs -f sqlbot-dify-mcp
```

停止服务：

```bash
sudo docker compose --env-file .env --env-file .env.sqlbot \
  -f docker-compose.yaml -f docker-compose.sqlbot.yaml stop
```

启动服务：

```bash
sudo docker compose --env-file .env --env-file .env.sqlbot \
  -f docker-compose.yaml -f docker-compose.sqlbot.yaml up -d --build
```

## 10. 安全说明

不要向公网开放以下端口：

- `8001`
- `8017`
- `15432`
- `5432`
- `5003`

不要提交 `.env` 到 Git。
