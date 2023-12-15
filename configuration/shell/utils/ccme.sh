#!/bin/bash

# :1,.s/;.\{0,8\}/;xxxxxxxx/g
# :1,.s/.\{0,12\}$/xxxxxxxx/g

file="$1"
varfile="$2"

for line in $(cat ${varfile})
do
	orig="$(echo $line | cut -d ';' -f1)"
	dest="$(echo $line | cut -d ';' -f2)"
	sed -i "s/$orig/$dest/g" $file
done
