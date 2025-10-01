Define an environment variable KAFKA_SERVICE_URI containing the URL to your Kafka service.  

For example:  
```export KAFKA_SERVICE_URI="<my service>.database.cloud.ovh.net:20186"```

Then copy in the [sslcerts](./sslcerts/) folder the files:
- ca.pem from your Kafka service CA certificate
- service.cert from your user certificate
- service.key from your user access key

Create a topic named ```heroes```

Now you can launch ```python consumer.py``` in a session and ```python producer.py``` in a another one.