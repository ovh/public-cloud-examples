# Copyright (c) 2025 OVHcloud
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import base64
import requests
from PIL import Image, ImageDraw
import io
from dotenv import load_dotenv

load_dotenv()

def create_test_image():
    """Create a simple test image for API testing"""
    # Create a 200x150 test image
    img = Image.new('RGB', (200, 150), color='lightblue')
    draw = ImageDraw.Draw(img)
    
    # Draw a simple car shape
    draw.rectangle([50, 60, 150, 110], fill='red', outline='black', width=2)
    draw.ellipse([60, 100, 80, 120], fill='black')  # Left wheel
    draw.ellipse([120, 100, 140, 120], fill='black')  # Right wheel
    draw.text((10, 10), "TEST CAR", fill='black')
    
    # Convert to base64
    buffer = io.BytesIO()
    img.save(buffer, format='PNG')
    buffer.seek(0)
    
    return base64.b64encode(buffer.getvalue()).decode('utf-8')

def test_vision_api():
    """Test OVHcloud Vision API connectivity"""
    token = os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN")
    url = os.getenv("QWEN_URL")
    model = "Qwen2.5-VL-72B-Instruct"  # Fixed model for demo
    
    if not token:
        print("❌ No token found. Check your .env file.")
        return False
    
    # Create test image
    test_image_b64 = create_test_image()
    
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    payload = {
        "model": model,
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "What do you see in this image? Describe it briefly."
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/png;base64,{test_image_b64}"
                        }
                    }
                ]
            }
        ],
        "max_tokens": 100,
        "temperature": 0.1
    }
    
    try:
        print("🔍 Testing OVHcloud Vision API...")
        response = requests.post(url, json=payload, headers=headers, timeout=30)
        
        if response.status_code == 200:
            result = response.json()
            ai_response = result['choices'][0]['message']['content']
            print(f"✅ Vision API works!")
            print(f"🤖 AI Response: {ai_response}")
            return True
        else:
            print(f"❌ API failed: {response.status_code}")
            print(f"Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Connection error: {e}")
        return False

if __name__ == "__main__":
    print("Testing OVHcloud Vision API connectivity...\n")
    
    if test_vision_api():
        print("\n🎉 Vision API is working! Ready for demo testing.")
    else:
        print("\n⚠️ Vision API test failed. Check your token and try again.")
