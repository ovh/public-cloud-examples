
## Usage and test

### Get necessary informations

The outputs give you usefull informations to connect to the server with SSH, and then to connect to the MongoDB database.

- `instance_floating_ip`: The virtual machine instance IP address (served by a floating IP).

- `mongodb_connection_string`: The mongodb connection string, that you will have to update with the database user name and password.

- `mongodb_user_password`: The mongodb user password (not displayed)

To get the password value, use the variable specific terraform output command:

```bash
terraform output mongodb_user_password
```

### Open a terminal onto the virtual machine instance

Connect to the `myserver` instance via SSH.

Use the created SSH keypair file and the IP address given by the `instance_floating_ip` value:

```bash
ssh -i myMainKeypair_rsa ubuntu@51.xx.xx.xx
```

When asked for continuing, answer yes:

```bash
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

You should have the bastion prompt:

```bash
ubuntu@myserver:~$
```

### Connect to the mongodb

```bash
mongosh "mongodb+srv://myuser:xxxxxxxxxxxxxxxx@mongodb-3378aeb1-obf0d5312.database.cloud.ovh.net/admin?replicaSet=replicaset&tls=true"
```

The output must be like this:

```bash
$ mongosh "mongodb+srv://myuser:xxxxxxxxxxxxxxxx@mongodb-3378aeb1-obf0d5312.database.cloud.ovh.net/admin?replicaSet=replicaset&tls=true"
Current Mongosh Log ID: 63b5bfe897ab5ae835212ca7
Connecting to:          mongodb+srv://<credentials>@mongodb-3378aeb1-obf0d5312.database.cloud.ovh.net/admin?replicaSet=replicaset&tls=true&appName=mongosh+1.6.1
Using MongoDB:          6.0.3
Using Mongosh:          1.6.1

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

replicaset [primary] admin>
```

