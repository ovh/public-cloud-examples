# Public cloud examples

![Work in progess](./docs/assets/wip.jpg)

Here is a list of examples which use multiple OVHcloud [Public Cloud products](https://www.ovhcloud.com/fr/public-cloud/).

You've developed a new cool feature? Fixed an annoying bug? We'd be happy to hear from you!

# 👀 Getting Started / configuration 🛠️

 - [Starting Pack to manage your OVHcloud Services from shell](./configuration/shell/README.md)
Follow this tutorial to setup your Public Cloud environment with your shell. 
That gives you the procedure to install and use many tools to manage the components described in examples, like Terraform, Ansible, Openstack CLI, OVHcloud API, and more.

# ✍️  Examples

All examples are organized depending on the main used product (Network, AI, ...).
Here is the several topics:
```bash
.
├── ai-machine-learning             ## Here you find demos about AI Products: AI Notebooks, AI Training and AI Deploy
├── containers-orchestration        ## Here you find demos about Kubernetes, Rancher and Harbor
│   ├── managed-kubernetes
│   └── managed-private-registry
├── databases-analytics             ## Here you find demo about databases, data streaming, data integration, ...
│   └── databases
├── iam                             ## Here you find demo about IAM (roles, identity, ...)
└── network                         ## Here you find demo about network (private network, load balancer, gateway, ...)
    └── private-network
```


# Related links

 * Contribute: https://github.com/ovh/public-cloud-examples/blob/master/CONTRIBUTING.md
 * Report bugs: https://github.com/ovh/public-cloud-examples/issues

# Contributing

Please read the [contributing guide](https://github.com/ovh/public-cloud-examples/blob/master/CONTRIBUTING.md) to learn about how you can contribute to this repository ;-). There is no small contribution, don't hesitate!

Our awesome contributors:

<a href="https://github.com/ovh/public-cloud-examples/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ovh/public-cloud-examples" />
</a>

# License

Copyright 2022-2023 OVH SAS

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
