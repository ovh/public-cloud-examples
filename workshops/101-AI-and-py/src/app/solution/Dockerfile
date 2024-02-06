FROM python:3.8

# set workspace as default WORKDIR
WORKDIR /workspace
# ADD requirements.txt to the default root folder
ADD requirements.txt /workspace

## RUN the pip install
RUN pip install -r requirements.txt
# add system dependencies for image manipulations
RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6  -y

# ADD python script to the root folder
ADD app.py /workspace

# Mandatory to run the jobs in rootless mode
RUN chown -R 42420:42420 /workspace

# run (CMD) the app.py
CMD [ "streamlit" , "run" , "/workspace/app.py", "--server.address=0.0.0.0" ]


#ENV HOME=/workspace