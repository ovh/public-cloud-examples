#!/bin/bash

# cat variables.tf | grep ^variable | cut -d '"' -f2 > vars.csv && cat resources.tf | grep ^resource | cut -d '"' -f4 >> vars.csv && cat data.tf | grep ^data | cut -d '"' -f4 >> vars.csv && cat outputs.tf | grep ^output | cut -d '"' -f2 >> vars.csv
#
# service_name;service_name
# pv_network_name;pv_network_name

file="$1"
varfile="$2"

for line in $(cat ${varfile})
do
	orig="$(echo $line | cut -d ';' -f1)"
	dest="$(echo $line | cut -d ';' -f2)"
	sed -i "s/$orig/$dest/g" $file
done
