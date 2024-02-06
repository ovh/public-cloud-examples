FROM --platform=linux/x86_64 python:3.8

# set workspace as default WORKDIR

# ADD requirements.txt to the default root folder

# add system dependencies for image manipulations
RUN apt-get update && apt-get install libgl1 -y
## RUN the pip install

# ADD python script to the default root folder

# Mandatory to run the jobs in rootless mode
RUN chown -R 42420:42420 /workspace

# run (CMD) the train.py
CMD [ "python3"  , "/workspace/train.py"]