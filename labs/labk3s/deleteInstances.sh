#!/bin/bash

SCRIPTROOTDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPTROOTDIR

source ./ovhrc
source ./properties

terraform destroy --auto-approve 

rm $(ls | egrep 'config-k3s[0-9][0-9][0-9]')
