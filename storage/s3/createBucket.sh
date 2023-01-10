#!/bin/bash
  
DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${DIR}

export AWS_ACCESS_KEY_ID="DUMMY_ACCESS_KEY_ID_NO_NEED_TO_CHANGE"
export AWS_SECRET_ACCESS_KEY="DUMMY_SECRET_KEY_NO_NEED_TO_CHANGE"
source ovhrc

terraform init

terraform plan
terraform apply --auto-approve
