FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY sqlbot_dify_mcp.py .

EXPOSE 8017
CMD ["uvicorn", "sqlbot_dify_mcp:app", "--host", "0.0.0.0", "--port", "8017"]
