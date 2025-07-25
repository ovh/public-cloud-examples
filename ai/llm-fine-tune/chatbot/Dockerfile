FROM python:3.13-slim

# 📂 Working directory in the container 📂
WORKDIR /workspace

# 🐍 Copy files in /workspace 🐍
COPY . /workspace

# ⬇️ Install any needed packages specified in requirements.txt ⬇️
RUN pip install --no-cache-dir -r requirements.txt

# 🔐 Change ownership of the workspace directory to the user with UID 42420 (OVHcloud user) 🔐
RUN chown -R 42420:42420 /workspace

# ⚙️ Make port 7860 available ⚙️
EXPOSE 7860

# ⚙️ Gradio configuration to run on localhost ⚙️
ENV GRADIO_SERVER_NAME="0.0.0.0"

# 🔐 Define default value for AI Endpoints API key 🔐
ENV OVH_AI_ENDPOINTS_ACCESS_TOKEN=$OVH_AI_ENDPOINTS_ACCESS_TOKEN

# ⚡️ Run chatbot.py when the container launches ⚡️
CMD ["python", "chatbot.py"]