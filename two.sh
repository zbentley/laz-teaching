#!/bin/bash

while read p;
do
LEN=$(echo ${#p})
if [ $LEN -gt 5 ]; then
echo ${p:0:5}
fi
done <words | head -10

