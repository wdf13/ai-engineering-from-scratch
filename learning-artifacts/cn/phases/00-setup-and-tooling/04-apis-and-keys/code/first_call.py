"""DeepSeek 版首次 API 调用。对照官方文档 https://api-docs.deepseek.com/

当前可用模型（2026-09 文档）：deepseek-flash、deepseek-v4-pro。
旧名 deepseek-chat / deepseek-reasoner 已停用，不要再用。
"""
import json
import os
import urllib.error
import urllib.request

MODEL = os.environ.get("LLM_MODEL", "deepseek-flash")
BASE_URL = "https://api.deepseek.com"


def call_with_sdk():
    try:
        from openai import OpenAI
    except ImportError:
        print("Install the SDK: pip install openai")
        return

    api_key = os.environ.get("DEEPSEEK_API_KEY")
    if not api_key:
        print("Set DEEPSEEK_API_KEY first")
        return

    client = OpenAI(api_key=api_key, base_url=BASE_URL)
    response = client.chat.completions.create(
        model=MODEL,
        max_tokens=256,
        messages=[{"role": "user", "content": "What is a neural network in one sentence?"}],
    )
    print(f"SDK response: {response.choices[0].message.content}")
    print(
        f"Tokens used: {response.usage.prompt_tokens} in, "
        f"{response.usage.completion_tokens} out"
    )


def call_raw_http():
    api_key = os.environ.get("DEEPSEEK_API_KEY")
    if not api_key:
        print("Set DEEPSEEK_API_KEY first")
        return

    url = BASE_URL.rstrip("/") + "/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + api_key,
    }
    body = json.dumps(
        {
            "model": MODEL,
            "max_tokens": 256,
            "messages": [
                {"role": "user", "content": "What is a neural network in one sentence?"}
            ],
            "stream": False,
        }
    ).encode()
    req = urllib.request.Request(url, data=body, headers=headers, method="POST")
    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read())
            print(f"Raw HTTP response: {result['choices'][0]['message']['content']}")
            print(
                f"Tokens used: {result['usage']['prompt_tokens']} in, "
                f"{result['usage']['completion_tokens']} out"
            )
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        print(f"Raw HTTP error: {exc.code} {exc.reason}")
        print(detail)


if __name__ == "__main__":
    print("=== API Calls ===\n")
    print("1. Using the SDK:")
    call_with_sdk()
    print("\n2. Using raw HTTP:")
    call_raw_http()
