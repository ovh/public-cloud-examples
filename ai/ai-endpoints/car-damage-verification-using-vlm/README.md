# VLM Tutorial - Car Damage Verification

This Vision Language Model (VLM) tutorial features an interactive car verification challenge powered by OVHcloud AI Endpoints.

## Files

- `test_vision_connection.py` - Test OVHcloud Vision API connectivity
- `verification_demo.py` - Core car verification logic using VLM
- `verification_app.py` - Interactive Chainlit web application
- `chainlit.md` - Welcome page content for the Chainlit app
- `requirements.txt` - Python dependencies

## What This Demo Does

The **Car Verification Challenge** is an interactive AI-powered fact-checking experiment where users:

1. **Make claims** about their car (manufacturer, model, color, damage)
2. **Upload photos** of the actual vehicle (minimum 3 photos)
3. **Get AI analysis** that verifies if the photos match their claims
4. **Receive a verdict** - did you tell the truth or try to trick the AI?

This demonstrates how Vision Language Models can analyze visual content and cross-reference it with textual claims for verification tasks.

## Usage

### 1. Prerequisites

Follow the [complete VLM tutorial setup guide](https://cougz.github.io/ovhcloud-workbooks/public-cloud/ai-endpoints/vlm-tutorial-car-damage-verfication/setup-guide/) for detailed setup instructions.

### 2. Environment Setup

Create a `.env` file with your OVHcloud credentials:
```
OVH_AI_ENDPOINTS_ACCESS_TOKEN=your_token_here
QWEN_URL=https://qwen-2-5-vl-72b-instruct.endpoints.kepler.ai.cloud.ovh.net/api/openai_compat/v1/chat/completions
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Test Connection

First, verify your API connectivity:
```bash
python test_vision_connection.py
```

### 5. Run the Interactive App

Launch the Chainlit web application:
```bash
chainlit run verification_app.py
```

Then open your browser to the provided URL (typically `http://localhost:8000`).

### 6. Test the Core Logic

You can also test the verification engine directly:
```bash
python verification_demo.py
```

## How It Works

### Vision Analysis Pipeline

1. **Image Processing**: Photos are optimized and converted to base64 for API transmission
2. **Multi-Modal Prompting**: The VLM receives both user claims (text) and photos (images)
3. **Verification Analysis**: AI analyzes each claim against visual evidence:
   - Manufacturer/brand identification
   - Model recognition
   - Color verification
   - Damage assessment
4. **Report Generation**: Detailed verification report with confidence levels and visual indicators

### Key Features

- **Multi-image analysis** - Processes up to 3 photos simultaneously
- **Structured verification** - Systematically checks each claim type
- **Enhanced formatting** - Green checkmarks (✅) for matches, red crosses (❌) for mismatches
- **Interactive interface** - User-friendly web application
- **Real-time processing** - Live verification with visual feedback

## Model Information

- **Vision Model**: Qwen2.5-VL-72B-Instruct
- **Provider**: OVHcloud AI Endpoints
- **Capabilities**: Multi-modal understanding, object detection, text-image reasoning
- **Optimizations**: Image compression, quality balancing for performance

## Requirements

See `requirements.txt` for all dependencies:
- `chainlit` - Interactive web interface
- `pillow` - Image processing
- `requests` - API communication
- `python-dotenv` - Environment management
- `aiofiles` - Async file operations

## Educational Value

This tutorial demonstrates:
- **Multi-modal AI applications** - Combining text and image analysis
- **Verification systems** - Using AI for fact-checking
- **Interactive AI interfaces** - Building engaging user experiences
- **Vision model integration** - Practical VLM implementation
- **Real-world applications** - Insurance, automotive, verification use cases

## Potential Extensions

- **Damage severity scoring** - Quantify damage levels
- **Multiple vehicle verification** - Compare multiple cars
- **Historical comparison** - Before/after damage analysis
- **Integration with databases** - Verify against vehicle registrations
- **Mobile app version** - Native mobile implementation

## Troubleshooting

- **Connection issues**: Run `test_vision_connection.py` to verify API access
- **Image upload problems**: Check file formats (PNG, JPG, JPEG, WebP supported)
- **Slow performance**: Reduce image sizes or number of photos
- **Token errors**: Verify your OVHcloud AI Endpoints token in `.env`
- **Formatting issues**: The enhanced formatting automatically adds checkmarks and structure

---

*Powered by OVHcloud AI Endpoints - Demonstrating the power of Vision Language Models for real-world verification tasks.*
