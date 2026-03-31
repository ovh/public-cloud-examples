#!/usr/bin/env python3
"""
OCR Demo using a vision-capable model via OpenAI-compatible API.
Extracts text from images using AI vision capabilities.

Requirements:
    pip install openai

Usage:
    python ocr_demo.py
"""

import base64
import os
from pathlib import Path

from openai import OpenAI

# System prompt for the OCR task
SYSTEM_PROMPT = """You are an expert OCR engine.
Extract every piece of text visible in the provided image.
Preserve the original layout as faithfully as possible (line breaks, columns, tables).
Do NOT interpret, summarise, or translate the content.
Use markdown formatting to represent the layout (e.g. tables, lists).
If the image contains no text, reply with: "No text found."
"""


def load_image_as_base64(path: Path) -> str:
    """Load a local image and encode it as base64."""
    with open(path, "rb") as f:
        return base64.b64encode(f.read()).decode("utf-8")


def extract_text(client: OpenAI, image_base64: str, model: str) -> str:
    """Extract text from an image using the vision model."""
    response = client.chat.completions.create(
        model=model,
        temperature=0.0,
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {
                "role": "user",
                "content": [
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/png;base64,{image_base64}"
                        }
                    }
                ]
            }
        ]
    )
    return response.choices[0].message.content


def main():
    image_path = Path("./doc.png")
    print(f"📄 Loading image: {image_path}")

    # Configure the OpenAI client for OVHcloud AI Endpoints
    client = OpenAI(
        api_key=os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN"),
        base_url=os.getenv("OVH_AI_ENDPOINTS_MODEL_URL"),
    )

    model_name = os.getenv("OVH_AI_ENDPOINTS_VLLM_MODEL")
    print(f"🔍 Running OCR with {model_name} via OVHcloud AI Endpoints...\n")

    image_base64 = load_image_as_base64(image_path)
    result = extract_text(client, image_base64, model_name)

    print("📝 Extracted text 📝")
    print(result)


if __name__ == "__main__":
    main()