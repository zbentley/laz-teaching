#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]];
do
echo "${line:0:1}";
done < "$1" | tr '[a-z]' -r | sort -r | uniq | head -26 

