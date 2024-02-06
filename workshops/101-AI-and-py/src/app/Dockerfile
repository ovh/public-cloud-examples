FROM python:3.8

# set workspace as default WORKDIR

# ADD requirements.txt to the default root folder

## RUN the pip install

# add system dependencies for image manipulations
RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6  -y

# ADD python script to the root folder

# Mandatory to run the jobs in rootless mode
RUN chown -R 42420:42420 /workspace

# run (CMD) the app.py

#ENV HOME=/workspace