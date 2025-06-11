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
import json
from typing import Dict, List, Any
import requests
from PIL import Image
import io
from dotenv import load_dotenv

load_dotenv()

class CarVerificationDemo:
    """Demo: Can AI verify if your car claims match reality?"""
    
    def __init__(self):
        self.token = os.getenv("OVH_AI_ENDPOINTS_ACCESS_TOKEN")
        self.url = os.getenv("QWEN_URL") 
        self.model = "Qwen2.5-VL-72B-Instruct"  # Fixed model for demo
        
        if not self.token:
            raise ValueError("Need your OVHcloud token to run this demo!")
        
        self.headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json"
        }

    def prepare_image_for_ai(self, image_data: bytes) -> str:
        """Optimize image for AI processing"""
        image = Image.open(io.BytesIO(image_data))
        
        # Keep it reasonable for demo
        if image.width > 1000 or image.height > 1000:
            image.thumbnail((1000, 1000), Image.Resampling.LANCZOS)
        
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        output = io.BytesIO()
        image.save(output, format='JPEG', quality=85)
        output.seek(0)
        
        return base64.b64encode(output.getvalue()).decode('utf-8')

    def verify_vehicle_claims(self, image_list: List[bytes], user_claims: Dict[str, str]) -> Dict[str, Any]:
        """The main verification: Do the photos match what the user claimed?"""
        
        if len(image_list) > 3:
            return {"error": "Let's keep it to 3 photos max for this demo!"}
        
        # Prepare all images
        encoded_images = []
        for img_data in image_list:
            encoded_images.append(self.prepare_image_for_ai(img_data))
        
        # Create verification prompt with user claims
        verification_prompt = f"""
        VERIFICATION CHALLENGE: Someone told me these details about their car, but I want you to check if the photos actually match what they claimed.

        THEIR CLAIMS:
        - Make/Manufacturer: {user_claims.get('manufacturer', 'Not specified')}
        - Model: {user_claims.get('model', 'Not specified')}
        - Color: {user_claims.get('color', 'Not specified')}
        - Damage Status: {user_claims.get('damage', 'Not specified')}

        YOUR JOB: Look at these photos and tell me:

        1. MANUFACTURER VERIFICATION:
           - What make/brand do you actually see in the photos?
           - Does this match their claim of "{user_claims.get('manufacturer', 'unknown')}"?
           - How confident are you?

        2. MODEL VERIFICATION:
           - What model do you think this actually is?
           - Does this match their claim of "{user_claims.get('model', 'unknown')}"?
           - Could you be wrong about the model?

        3. COLOR VERIFICATION:
           - What color is this car in the photos?
           - Does this match their claim of "{user_claims.get('color', 'unknown')}"?
           - Any color variations or damage affecting color?

        4. DAMAGE VERIFICATION:
           - What damage do you actually see (if any)?
           - They claimed: "{user_claims.get('damage', 'unknown')}"
           - Does what you see match what they said?

        5. OVERALL VERDICT:
           - Do the photos generally match their claims?
           - What discrepancies did you find?
           - Anything suspicious or inconsistent?

        Be honest about what you can and can't tell from these photos!
        """
        
        # Build content for multi-image analysis
        content = [{"type": "text", "text": verification_prompt}]
        
        # Add all images to the request
        for img_b64 in encoded_images:
            content.append({
                "type": "image_url",
                "image_url": {"url": f"data:image/jpeg;base64,{img_b64}"}
            })
        
        payload = {
            "model": self.model,
            "messages": [{"role": "user", "content": content}],
            "max_tokens": 1000,
            "temperature": 0.1  # Low temperature for consistent verification
        }
        
        try:
            response = requests.post(self.url, json=payload, headers=self.headers, timeout=60)
            
            if response.status_code == 200:
                result = response.json()
                return {
                    "success": True,
                    "verification_report": result['choices'][0]['message']['content'],
                    "photos_analyzed": len(image_list),
                    "user_claims": user_claims
                }
            else:
                return {
                    "success": False,
                    "error": f"API returned {response.status_code}"
                }
                
        except Exception as e:
            return {
                "success": False,
                "error": f"Verification failed: {str(e)}"
            }

# Test the demo engine
if __name__ == "__main__":
    demo = CarVerificationDemo()
    print("✅ Car Verification Demo ready!")
    print("🕵️ Let's see if AI can catch inconsistencies!")
    print("📸 Upload photos and make some claims to test!")
