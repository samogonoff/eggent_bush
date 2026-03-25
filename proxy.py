from fastapi import FastAPI, Request
import httpx
import json

app = FastAPI()

ZEN_API_KEY = "sk-BXHKRTdrAA3deyXUkOIBw76Amz53eZFZBfQfDjp5UKmY7Br0vS0xN7eZzom4Ybs1"
ZEN_BASE_URL = "https://opencode.ai/zen/v1"


@app.api_route("/v1/messages", methods=["POST"])
async def messages(request: Request, beta: bool = False):
    body = await request.json()
    if body.get("model") == "claude-haiku-4-5-20251001":
        body["model"] = "claude-haiku-4-5"

    async with httpx.AsyncClient() as client:
        resp = await client.post(
            f"{ZEN_BASE_URL}/v1/messages",
            json=body,
            headers={
                "Authorization": f"Bearer {ZEN_API_KEY}",
                "Content-Type": "application/json",
                "anthropic-version": request.headers.get("anthropic-version", "2023-06-01")
            }
        )

    # Логируем статус и тело ответа
    print(f"ZEN response status: {resp.status_code}")
    print(f"ZEN response headers: {resp.headers}")
    print(f"ZEN response body: {resp.text[:500]}")  # выводим первые 500 символов

    # Пытаемся вернуть JSON, но если не получается, возвращаем ошибку
    try:
        return resp.json()
    except json.JSONDecodeError:
        return {"error": "ZEN returned non-JSON", "status": resp.status_code, "body": resp.text}


@app.api_route("/v1/models", methods=["GET"])
async def models():
    return {
        "data": [
            {"id": "claude-haiku-4-5-20251001", "object": "model", "created": 1677610602, "owned_by": "opencode"}
        ]
    }