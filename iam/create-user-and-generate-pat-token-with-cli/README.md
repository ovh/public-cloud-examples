## Create an IAM local user and generate its PAT token with the ovhcloud CLI

### General information
 - 🔗 [Getting Started with OVHcloud CLI](https://help.ovhcloud.com/csm/en-gb-cli-getting-started?id=kb_article_view&sysparm_article=KB0072707)

### Set up
  - [ovhcloud CLI](https://github.com/ovh/ovhcloud-cli/) CLI installed & configured

### Demo
  - Create an IAM local user:

```
$ ovhcloud iam user create --login <login> --group <group>> --description <description> --password <password> --email <email> 

Example:
```
$ ovhcloud iam user create --login "secretmanager-123456-7890-1234-5687-aabbccddee-test" --group ADMIN --description "A user create for secretmanager, linked to 123456-7890-1234-5687-aabbccddee" --password "secretmanager-123456-7890-1234-5687-aabbccddee" --email "secretmanager-123456-7890-1234-5687-aabbccddee@ovhcloud.com"

2025/12/18 15:37:33 Final parameters:
{
 "description": "A user create for secretmanager, linked to 123456-7890-1234-5687-aabbccddee",
 "email": "secretmanager-123456-7890-1234-5687-aabbccddee@ovhcloud.com",
 "group": "ADMIN",
 "login": "secretmanager-123456-7890-1234-5687-aabbccddee-test",
 "password": "secretmanager-123456-7890-1234-5687-aabbccddee"
}
✅ User secretmanager-123456-7890-1234-5687-aabbccddee-test created successfully
```

List users:

```
$ ovhcloud iam user list
┌─────────────────────────────────────────────────────────┬──────────────┬─────────────────────────────────────────────────────────────────────────────────┐
│                          login                          │    group     │                                   description                                   │
├─────────────────────────────────────────────────────────┼──────────────┼─────────────────────────────────────────────────────────────────────────────────┤
│ ai-endpoint-user      │ UNPRIVILEGED │ A user created for AI endpoints, linked to xxxxxxxxxxxxxxxxxxxx     │
│ ai-endpoints-user-aabbccddee      │ UNPRIVILEGED │ A user created for AI endpoints, linked to aabbccddee     │
│ secretmanager-123456-7890-1234-5687-aabbccddee      │ ADMIN        │ A user create for secretmanager, linked to 123456-7890-1234-5687-aabbccddee │
└─────────────────────────────────────────────────────────┴──────────────┴─────────────────────────────────────────────────────────────────────────────────┘
💡 Use option --json or --yaml to get the raw output with all information
```

  - Generate a PAT token (and save it in an environment variable):

```
ovhcloud iam user token create <user> --name <name> --description <description>
```

Example:
```
$ PAT_TOKEN=$(ovhcloud iam user token create secretmanager-b1033fdd-0cb1-41e9-9a1d-c4e5eb244f3a-test --name pat-secretmanager-b1033fdd-0cb1-41e9-9a1d-c4e5eb244f3a-test6 --description "PAT secret manager for domain secretmanager-b1033fdd-0cb1-41e9-9a1d-c4e5eb244f3a" -j  | jq .details.token |  tr -d '"')
2025/12/18 16:03:11 Final parameters:
{
 "description": "PAT secret manager for domain secretmanager-b1033fdd-0cb1-41e9-9a1d-c4e5eb244f3a",
 "name": "pat-secretmanager-b1033fdd-0cb1-41e9-9a1d-c4e5eb244f3a-test7"
}

echo $PAT_TOKEN
<your-token>
```

🎉

Note: If the PAT_TOKEN is equals to null, execute the command and check the error message.

