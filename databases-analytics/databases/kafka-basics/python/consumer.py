import os

from confluent_kafka import Consumer, KafkaException
from rich.console import Console

# retrieve URI to connect to your Kafka service from your OS environment variables
KAFKA_SERVICE_URI = os.getenv("KAFKA_SERVICE_URI")
if KAFKA_SERVICE_URI is None:
    raise ValueError("KAFKA_SERVICE_URI is not set")

# set up the configuration to access your Kafka service in a secure way
conf = {
    "bootstrap.servers": KAFKA_SERVICE_URI,
    "client.id": "customer",
    "group.id": "readers",
    "security.protocol": "SSL",
    "ssl.ca.location": "./sslcerts/ca.pem",
    "ssl.certificate.location": "./sslcerts/service.cert",
    "ssl.key.location": "./sslcerts/service.key",
}

# create a Kafka consumer instance
consumer = Consumer(conf)

# create a console instance to display messages in a TUI
console = Console()

finished = False
local_count = 0

# subscribe to the "heroes" topic and wait for a message
consumer.subscribe(["heroes"])
with console.status("Waiting for messages..."):
    while not finished:
        if (msg := consumer.poll(timeout=1.0)) is None:
            continue
        elif msg.error():
            raise KafkaException(msg.error())
        else:
            console.print(f"{msg.offset()}: {msg.key()}:{msg.value().decode()}\n\n")
            local_count += 1
            finished = local_count == 2
