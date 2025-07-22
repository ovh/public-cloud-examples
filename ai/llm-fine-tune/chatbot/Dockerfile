# Use an official Python runtime as a parent image
FROM python:3.13-slim

# Set the working directory in the container
WORKDIR /workspace

# Copy the current directory contents into the container at /app
COPY . /workspace

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN chown -R 42420:42420 /workspace

# Make port 8080 available to the world outside this container
EXPOSE 7860
ENV GRADIO_SERVER_NAME="0.0.0.0"

# Define environment variable
ENV OVH_AI_ENDPOINTS_ACCESS_TOKEN=$OVH_AI_ENDPOINTS_ACCESS_TOKEN

# Run chatbot.py when the container launches
CMD ["python", "chatbot.py"]