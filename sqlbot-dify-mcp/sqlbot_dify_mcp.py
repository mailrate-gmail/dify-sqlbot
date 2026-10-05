import base64
import json
import os
import uuid
from typing import Any

import requests
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse, StreamingResponse

app = FastAPI()

SQLBOT_BASE_URL = os.getenv("SQLBOT_BASE_URL", "http://127.0.0.1:8000")
SQLBOT_USERNAME = os.getenv("SQLBOT_USERNAME", "admin")
SQLBOT_PASSWORD = os.getenv("SQLBOT_PASSWORD")

sessions: dict[str, dict[str, Any]] = {}


def _require_password() -> str:
    if not SQLBOT_PASSWORD:
        raise RuntimeError("SQLBOT_PASSWORD environment variable is required")
    return SQLBOT_PASSWORD


def _post(path: str, payload: Any) -> dict[str, Any]:
    response = requests.post(
        f"{SQLBOT_BASE_URL}{path}",
        json=payload,
        timeout=120,
    )
    response.raise_for_status()
    data = response.json()
    if data.get("code") not in (0, None):
        raise RuntimeError(data.get("msg") or data)
    return data.get("data", data)


def _post_raw(path: str, payload: Any) -> dict[str, Any]:
    response = requests.post(
        f"{SQLBOT_BASE_URL}{path}",
        json=payload,
        timeout=120,
    )
    response.raise_for_status()
    data = response.json()
    if data.get("code") not in (0, None):
        raise RuntimeError(data.get("msg") or data)
    return data


def _start_chat() -> dict[str, Any]:
    return _post(
        "/api/v1/mcp/mcp_start",
        {"username": SQLBOT_USERNAME, "password": _require_password()},
    )


def _text_result(text: str, request_id: Any) -> dict[str, Any]:
    return {
        "jsonrpc": "2.0",
        "id": request_id,
        "result": {"content": [{"type": "text", "text": text}]},
    }


def _decode_sql(encoded_sql: str | None) -> str:
    if not encoded_sql:
        return ""
    try:
        return base64.b64decode(encoded_sql).decode("utf-8")
    except Exception:
        return encoded_sql


def _markdown_table(fields: list[str], rows: list[dict[str, Any]]) -> str:
    if not fields:
        return ""
    header = "| " + " | ".join(fields) + " |"
    sep = "| " + " | ".join(["---"] * len(fields)) + " |"
    body = []
    for row in rows:
        body.append("| " + " | ".join(str(row.get(field, "")) for field in fields) + " |")
    if not body:
        body.append("| " + " | ".join(["无数据"] + [""] * (len(fields) - 1)) + " |")
    return "\n".join([header, sep, *body])


def _chart_fields(fields_info: list[dict[str, Any]], rows: list[dict[str, Any]]) -> tuple[str, str] | None:
    if not rows:
        return None
    numeric_fields = [item["name"] for item in fields_info if item.get("is_numeric")]
    label_fields = [item["name"] for item in fields_info if not item.get("is_numeric")]
    if not numeric_fields or not label_fields:
        return None
    return label_fields[0], numeric_fields[0]


def _echarts_option(title: str, fields_info: list[dict[str, Any]], rows: list[dict[str, Any]]) -> dict[str, Any] | None:
    chart_fields = _chart_fields(fields_info, rows)
    if not chart_fields:
        return None
    label_field, value_field = chart_fields
    labels = [str(row.get(label_field, "")) for row in rows]
    values = []
    for row in rows:
        try:
            values.append(float(row.get(value_field) or 0))
        except (TypeError, ValueError):
            values.append(0)
    return {
        "title": {"text": title or f"{value_field} 柱状图", "left": "center"},
        "tooltip": {"trigger": "axis"},
        "grid": {"left": "3%", "right": "4%", "bottom": "3%", "containLabel": True},
        "xAxis": {"type": "category", "data": labels},
        "yAxis": {"type": "value"},
        "series": [
            {
                "name": value_field,
                "type": "bar",
                "data": values,
                "label": {"show": True, "position": "top"},
            }
        ],
    }


def _format_sqlbot_answer(raw: dict[str, Any]) -> str:
    if not raw.get("success"):
        return raw.get("message") or json.dumps(raw, ensure_ascii=False, indent=2)

    result_data = raw.get("data") or {}
    fields = result_data.get("fields") or []
    rows = result_data.get("data") or []
    fields_info = result_data.get("fields_info") or []
    sql = raw.get("sql") or _decode_sql(result_data.get("sql"))
    chart = raw.get("chart") or {}

    parts = []
    if raw.get("title"):
        parts.append(f"## {raw['title']}")
    if fields:
        parts.append("**表格结果**\n")
        parts.append(_markdown_table(fields, rows))
    option = _echarts_option(chart.get("title") or raw.get("title") or "SQLBot 图表", fields_info, rows)
    if option:
        parts.append("\n**ECharts 图表**\n")
        parts.append(f"```echarts\n{json.dumps(option, ensure_ascii=False, indent=2)}\n```")
    if sql:
        parts.append("\n**生成 SQL**\n")
        parts.append(f"```sql\n{sql}\n```")
    return "\n\n".join(parts) if parts else json.dumps(raw, ensure_ascii=False, indent=2)


def _tools() -> list[dict[str, Any]]:
    return [
        {
            "name": "sqlbot_ask",
            "description": "调用 SQLBot 进行智能问数，返回 Markdown 表格、ECharts 图表和生成 SQL。",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "question": {"type": "string", "description": "自然语言问数问题"},
                    "datasource_id": {
                        "type": "string",
                        "description": "可选，SQLBot 数据源 ID。不填则由 SQLBot 根据会话判断。",
                    },
                    "return_img": {
                        "type": "boolean",
                        "description": "是否让 SQLBot 返回图表附件。默认 false；Dify 演示使用 ECharts 文本渲染。",
                        "default": False,
                    },
                },
                "required": ["question"],
            },
        },
        {
            "name": "sqlbot_datasource_list",
            "description": "列出当前 SQLBot 用户可见的数据源。",
            "inputSchema": {"type": "object", "properties": {}},
        },
    ]


def _handle_tool_call(name: str, arguments: dict[str, Any], request_id: Any) -> dict[str, Any]:
    chat = _start_chat()
    token = chat["access_token"]

    if name == "sqlbot_datasource_list":
        data = _post("/api/v1/mcp/mcp_ds_list", {"token": token})
        return _text_result(json.dumps(data, ensure_ascii=False, indent=2), request_id)

    if name == "sqlbot_ask":
        if not arguments.get("question"):
            raise ValueError("question is required")
        payload = {
            "token": token,
            "chat_id": chat["chat_id"],
            "question": arguments["question"],
            "stream": False,
            "return_img": bool(arguments.get("return_img", False)),
        }
        if arguments.get("datasource_id"):
            payload["datasource_id"] = arguments["datasource_id"]
        data = _post_raw("/api/v1/mcp/mcp_question", payload)
        return _text_result(_format_sqlbot_answer(data), request_id)

    return {"jsonrpc": "2.0", "id": request_id, "error": {"code": -32601, "message": "Tool not found"}}


async def handle_jsonrpc(message: dict[str, Any]) -> dict[str, Any]:
    method = message.get("method")
    request_id = message.get("id")

    if method == "initialize":
        return {
            "jsonrpc": "2.0",
            "id": request_id,
            "result": {
                "protocolVersion": "2025-06-18",
                "capabilities": {"tools": {"listChanged": False}},
                "serverInfo": {"name": "sqlbot-dify-mcp", "version": "1.0.0"},
            },
        }

    if method == "notifications/initialized":
        return {"jsonrpc": "2.0", "result": {}}

    if method == "tools/list":
        return {"jsonrpc": "2.0", "id": request_id, "result": {"tools": _tools()}}

    if method == "tools/call":
        params = message.get("params") or {}
        try:
            return _handle_tool_call(params.get("name"), params.get("arguments") or {}, request_id)
        except Exception as exc:
            return {
                "jsonrpc": "2.0",
                "id": request_id,
                "error": {"code": -32000, "message": str(exc)},
            }

    return {"jsonrpc": "2.0", "id": request_id, "error": {"code": -32601, "message": "Method not found"}}


@app.post("/mcp")
async def post_mcp(request: Request):
    message = await request.json()
    session_id = request.headers.get("Mcp-Session-Id") or str(uuid.uuid4())
    sessions.setdefault(session_id, {})
    response = await handle_jsonrpc(message)
    return JSONResponse(content=response, headers={"Mcp-Session-Id": session_id})


@app.get("/mcp")
async def get_mcp(request: Request):
    session_id = request.headers.get("Mcp-Session-Id") or str(uuid.uuid4())
    sessions.setdefault(session_id, {})

    async def stream():
        yield ": sqlbot-dify-mcp ready\n\n"

    return StreamingResponse(stream(), media_type="text/event-stream", headers={"Mcp-Session-Id": session_id})


@app.get("/health")
async def health():
    return {"status": "ok"}
