import os
from confluent_kafka import Producer

# retrieve URI to connect to your Kafka service from your OS environment variables
KAFKA_SERVICE_URI = os.getenv("KAFKA_SERVICE_URI")
if KAFKA_SERVICE_URI is None:
    raise ValueError("KAFKA_SERVICE_URI is not set")

# set up the configuration to access your Kafka service in a secure way
conf = {
    "bootstrap.servers": KAFKA_SERVICE_URI,
    "client.id": "producer",
    "security.protocol": "SSL",
    "ssl.ca.location": "./sslcerts/ca.pem",
    "ssl.certificate.location": "./sslcerts/service.cert",
    "ssl.key.location": "./sslcerts/service.key",
}

# create a Kafka producer instance
producer = Producer(conf)


# when the message is published, this callback will be triggered
def delivery_callback(err, msg):
    if err:
        print(f"Message failed delivery: {err}")
    else:
        print(f"Published event to topic {msg.topic()} ")


# example data to send as a message
jsonValue = """{
        'id': 1,
        'name': 'Spider-Man (Peter Parker)',
        'description': 'Bitten by a radioactive spider, high school student Peter Parker gained the speed, strength and powers of a spider. Adopting the name Spider-Man, Peter hoped to start a career using his new abilities. Taught that with great power comes great responsibility, Spidey has vowed to use his powers to help people.',
    }"""

# create and publish the message to the "heroes" topic
producer.produce(
    "heroes", key="1", value=jsonValue.encode(), callback=delivery_callback
)
producer.flush()
