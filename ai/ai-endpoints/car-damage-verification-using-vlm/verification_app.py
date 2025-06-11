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

import chainlit as cl
from verification_demo import CarVerificationDemo
import aiofiles
from typing import Dict, List
import re

demo = CarVerificationDemo()

class VerificationState:
    """Manages verification session state"""
    
    def __init__(self):
        self.user_claims = {}
        self.current_step = "welcome"
        self.car_photos = []
    
    @classmethod
    def get_instance(cls):
        """Get or create session state instance"""
        state = cl.user_session.get("verification_state")
        if not state:
            state = cls()
            cl.user_session.set("verification_state", state)
        return state
    
    def set_claim(self, claim_type: str, value: str):
        """Set a user claim"""
        self.user_claims[claim_type] = value
        cl.user_session.set("verification_state", self)
    
    def set_step(self, step: str):
        """Set current verification step"""
        self.current_step = step
        cl.user_session.set("verification_state", self)
    
    def add_photos(self, photos: List[Dict]):
        """Add photos to session"""
        self.car_photos.extend(photos)
        cl.user_session.set("verification_state", self)
    
    def clear_photos(self):
        """Clear all photos"""
        self.car_photos = []
        cl.user_session.set("verification_state", self)


@cl.on_chat_start
async def start_verification():
    """Welcome to the car verification challenge!"""
    VerificationState.get_instance()
    
    await cl.Message(
        content="""
What **manufacturer/brand** is your car? (BMW, Toyota, Honda, etc.)

*Feel free to tell the truth... or try to trick the AI! 😉*
        """,
        author="Verification AI"
    ).send()

@cl.on_message
async def handle_verification_step(message: cl.Message):
    """Handle each step of the verification process"""
    state = VerificationState.get_instance()
    current_step = state.current_step
    
    if current_step == "welcome":
        await collect_claim("manufacturer", message.content, "model", 1, "Now, what **model** is it? (Camry, Civic, 3 Series, Aventador, etc.)")
    elif current_step == "model":
        await collect_claim("model", message.content, "color", 2, "What **color** is your car?")
    elif current_step == "color":
        await collect_claim("color", message.content, "damage", 3, "Finally, describe any **damage** to your car. If there's no damage, just say \"no damage\" or \"perfect condition\".\n\nExamples:\n- \"dent on front bumper\"\n- \"scratch on driver door\"  \n- \"no damage\"\n- \"minor scratches on rear\"")
    elif current_step == "damage":
        await collect_claim("damage", message.content, "photos", 4, "")
    elif current_step == "photos":
        # Check if the message contains actual image files
        image_elements = [
            el for el in message.elements 
            if el.path and ("image" in el.mime if el.mime else el.name.lower().endswith(('.png', '.jpg', '.jpeg', '.webp')))
        ]
        if image_elements:
            await collect_photos(message) 
        else:
            # If user sends text instead of photos when photos are expected
            await cl.Message(
                content="📸 Please upload your photos by clicking the paperclip (📎) icon.",
                author="Verification AI"
            ).send()

async def collect_claim(claim_type: str, value: str, next_step: str, claim_number: int, next_prompt: str):
    """Collect a user claim and advance to next step"""
    value = value.strip()
    state = VerificationState.get_instance()
    state.set_claim(claim_type, value)
    state.set_step(next_step)
    user_claims = state.user_claims
    
    if claim_number == 1:
        content = f"📝 **Claim #{claim_number}:** {value} ✅\n\n{next_prompt}"
    elif claim_number == 2:
        content = f"📝 **Claim #{claim_number}:** {user_claims.get('manufacturer', 'Unknown Make')} {value} ✅\n\n{next_prompt}"
    elif claim_number == 3:
        content = f"📝 **Claim #{claim_number}:** {value} {user_claims.get('manufacturer', '')} {user_claims.get('model', '')} ✅\n\n{next_prompt}"
    else:
        content = f"""📝 **Claim #{claim_number}:** {value} ✅

## 📋 Your Claims Summary:
- **Car:** {user_claims.get("manufacturer", "N/A")} {user_claims.get("model", "N/A")}
- **Color:** {user_claims.get("color", "N/A")}
- **Damage:** {value}

## 📸 Now the moment of truth!

Upload **at least 3 photos** of your car so the AI can verify if you're telling the truth!

**Upload your photos now!**"""
    
    await cl.Message(content=content, author="Verification AI").send()

async def collect_photos(message: cl.Message):
    """Process uploaded photos and start verification"""
    state = VerificationState.get_instance()
    car_photos_session = state.car_photos
    new_photos_data: List[Dict] = []
    
    image_elements = [
        el for el in message.elements 
        if el.path and ("image" in el.mime if el.mime else el.name.lower().endswith(('.png', '.jpg', '.jpeg', '.webp')))
    ]

    for element in image_elements:
        try:
            async with aiofiles.open(element.path, 'rb') as f:
                image_byte_data = await f.read()
            new_photos_data.append({"name": element.name, "data": image_byte_data, "path": element.path})
        except Exception as e:
            print(f"Error reading file {element.name}: {e}")
            await cl.Message(content=f"Error processing image {element.name}. Please try again.", author="Verification AI").send()
            # Continue to process other images if any
    
    if not new_photos_data and not image_elements: # If message.elements had non-images, or other error
        if not car_photos_session: # If no photos at all and no new ones successfully read
             await cl.Message(content="No valid image files received. Please upload photos.", author="Verification AI").send()
        return
    
    if new_photos_data:
        state.add_photos(new_photos_data)
        car_photos_session = state.car_photos
        
        await cl.Message( 
            content=f"Successfully processed {len(new_photos_data)} new photo(s). Total: {len(car_photos_session)}.",
            author="Verification AI"
        ).send()

    if len(car_photos_session) >= 3:
        await run_verification()
    else:
        await cl.Message(
            content=f"📸 Need {3 - len(car_photos_session)} more photo(s) for verification. Please upload more.",
            author="Verification AI"
        ).send()

async def run_verification():
    """Run the AI verification process"""
    state = VerificationState.get_instance()
    user_claims = state.user_claims
    car_photos_session = state.car_photos
    
    processing_msg = cl.Message(content="", author="Verification AI") # Initial empty message
    await processing_msg.send()
    processing_msg.content = "🕵️ **Starting AI Verification...** This may take 30-60 seconds..."
    await processing_msg.update()
    
    try:
        image_data_list = [photo["data"] for photo in car_photos_session[:3]]
        
        async_verify_vehicle_claims = cl.make_async(demo.verify_vehicle_claims)
        verification_result = await async_verify_vehicle_claims(image_data_list, user_claims)
        
        if verification_result and verification_result.get("success"):
            await processing_msg.remove() 
            await show_verification_results(verification_result)
        else:
            error_message = verification_result.get('error', 'Unknown error during verification.')
            await processing_msg.update(content=f"❌ **Verification Failed:** {error_message}")
            state.set_step("photos")
            state.clear_photos() # Clear photos to allow fresh uploads

    except Exception as e:
        detailed_error_message = f"An unexpected error occurred: {str(e)}"
        print(f"Error during verification: {detailed_error_message}") # Log to console
        await processing_msg.update(content=f"❌ **Error during verification:** {detailed_error_message}")
        state.set_step("photos")
        state.clear_photos()

def format_verification_report(report: str) -> str:
    """Enhanced formatting for verification reports with proper checkmarks and structure"""
    
    # Split into lines for processing
    lines = report.split('\n')
    formatted_lines = []
    
    for line in lines:
        stripped = line.strip()
        
        # Skip empty lines
        if not stripped:
            formatted_lines.append("")
            continue
            
        # Format numbered verification sections (1., 2., 3., etc.)
        if re.match(r'^\d+\.\s+\w+\s+VERIFICATION:', stripped):
            formatted_lines.append(f"\n## {stripped}")
            continue
            
        # Format OVERALL VERDICT section specially
        if "OVERALL VERDICT" in stripped:
            formatted_lines.append(f"\n## 🏁 OVERALL VERDICT:")
            continue
            
        # Format bullet points with checkmarks/crosses
        if stripped.startswith('* '):
            bullet_text = stripped[2:].strip()
            
            # Check for positive responses (matches)
            if any(phrase in bullet_text for phrase in [
                "Yes, it matches their claim", "Yes, this matches their claim",
                "matches their claim perfectly", "matches their claim accurately",
                "Yes, it matches", "Very confident", "perfectly matches",
                "accurately matches", "correct", "Yes, the photos generally match"
            ]):
                formatted_lines.append(f"  ✅ **{bullet_text}**")
            # Check for negative responses (doesn't match)
            elif any(phrase in bullet_text for phrase in [
                "No, it does not match their claim", "No, this does not match their claim", 
                "does not match their claim", "doesn't match their claim",
                "No, it doesn't fully match", "contradicting their statement",
                "inconsistencies", "discrepancies", "suspicious", "No, the photos",
                "The main discrepancies are", "doesn't fully match"
            ]):
                formatted_lines.append(f"  ❌ **{bullet_text}**")
            else:
                # Regular bullet point for neutral information
                formatted_lines.append(f"  • {bullet_text}")
            continue
            
        # Add checkmarks to standalone Yes/No responses
        if stripped.startswith(("Yes,", "No,")):
            if stripped.startswith("Yes,"):
                formatted_lines.append(f"✅ {stripped}")
            else:
                formatted_lines.append(f"❌ {stripped}")
            continue
        
        # Handle summary sections
        if stripped.startswith("In summary"):
            formatted_lines.append(f"\n**{stripped}**")
            continue
            
        # Default: add line as-is with proper indentation
        if line.startswith(' ') and not line.startswith('  '):
            # Single space indent - make it a regular paragraph
            formatted_lines.append(line.strip())
        else:
            formatted_lines.append(line)
    
    return '\n'.join(formatted_lines)

async def show_verification_results(verification_result: Dict):
    """Display the verification results with enhanced formatting"""
    state = VerificationState.get_instance()
    user_claims = state.user_claims
    original_report = verification_result.get("verification_report", "No report generated.")

    # Apply enhanced formatting
    formatted_report = format_verification_report(original_report)
    
    await cl.Message(
        content=f"""# 🎉 Verification Complete!

## 📋 What You Claimed:
- **Manufacturer:** {user_claims.get('manufacturer', 'N/A')}
- **Model:** {user_claims.get('model', 'N/A')}
- **Color:** {user_claims.get('color', 'N/A')}
- **Damage:** {user_claims.get('damage', 'N/A')}

## 🤖 What the AI Actually Saw:""",
        author="Verification AI"
    ).send()
    
    await cl.Message(
        content=formatted_report,
        author="AI Analysis"
    ).send()

