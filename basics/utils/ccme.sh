#!/bin/bash

# cat variables.tf | grep ^variable | cut -d '"' -f2 > vars.csv && cat resources.tf | grep ^resource | cut -d '"' -f4 >> vars.csv && cat data.tf | grep ^data | cut -d '"' -f4 >> vars.csv && cat outputs.tf | grep ^output | cut -d '"' -f2 >> vars.csv
#
# service_name;service_name
# pv_network_name;pv_network_name

for line in $(cat vars.csv)
do
	orig="$(echo $line | cut -d ';' -f1)"
	dest="$(echo $line | cut -d ';' -f2)"

	for fic in $(grep $orig * 2>>/dev/null | cut -d ':' -f1 | grep -v vars.csv)
	do
		echo "$orig in $fic"
		sed -i "s/$orig/$dest/g" $fic
	done
done
