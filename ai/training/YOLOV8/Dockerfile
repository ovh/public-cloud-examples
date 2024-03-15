FROM alpine:3.19 AS certs

RUN apk update && \
    apk --no-cache add tzdata && \
    apk --no-cache add ca-certificates && rm -rf /var/cache/apk/* && \
    apk add --no-cache python3 py3-pip && \
    apk --no-cache add ca-certificates wget && \
    # see https://github.com/sgerrand/alpine-pkg-glibc
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk && \
    apk add --no-cache glibc-2.35-r1.apk

FROM scratch
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=certs /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=certs /etc/passwd /etc/passwd

# set workspace as default WORKDIR
WORKDIR /workspace
# ADD requirements.txt to the default root folder
ADD requirements.txt /workspace

## RUN the pip install
RUN pip install -r requirements.txt

# ADD python script to the root folder
ADD train.py /workspace

# Mandatory to run the jobs in rootless mode
RUN chown -R 42420:42420 /workspace

# run (CMD) the train.py
CMD [ "python3"  , "/workspace/train.py"]