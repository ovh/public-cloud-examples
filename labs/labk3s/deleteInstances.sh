#!/bin/bash

app="labk3s"

DIR="/workspace/OVHcloud-small-recipes"
cd ${DIR}/$app

terraform destroy --auto-approve 

rm $(ls | egrep 'config-k3s[0-9][0-9][0-9]')
