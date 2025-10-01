FROM python:3.11

WORKDIR /workspace
ADD . /workspace

RUN apt-get update && apt-get install -y ffmpeg libsndfile1-dev
RUN pip install -r requirements.txt

RUN chown -R 42420:42420 /workspace
ENV HOME=/workspace
CMD [ "python3" , "/workspace/main.py" ]